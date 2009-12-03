#
#	vim:ft=make:fenc=UTF-8:ts=4:sts=0:sw=4:noexpandtab:foldmethod=marker:foldlevel=0:
#
#	lblmail is a small utility written in PHP, it allow you to label emails based on
#	rules à la procmail, the advantage over procmail is the ability to apply the label
#	to the given mail file, which means you can post-process the mail.
#
#	Copyright (c) 2007 Wael Nasreddine <wael.nasreddine@gmail.com>
#
#	This file is part of LblMail.
#
#	LblMail is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	(at your option) any later version.
#
#	LblMail is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with LblMail.  If not, see <http://www.gnu.org/licenses/>.
#


# TODO: Parse the version from git log
#       version="$(git log -1 --abbrev-commit --oneline 2>| /dev/null || echo 'unknow')"; echo $version | awk '{print $1}'
VERSION=0.1

prefix=/usr/local
bindir=$(prefix)/bin
libdir=$(prefix)/lib/lblmail
sharedir=$(prefix)/share/lblmail
INSTALL=install
MAKE=make
SUBDIRS = bin lib share

all: dist targets;

dist: ChangeLog AUTHORS

ChangeLog:
	(GIT_DIR=.git git log > .changelog.tmp && mv .changelog.tmp ChangeLog; rm -f .changelog.tmp) || (touch ChangeLog; echo 'git directory not found: installing possibly empty changelog.' >&2)
	  
AUTHORS:
	(GIT_DIR=.git git log | grep ^Author | sort |uniq > .authors.tmp && mv .authors.tmp AUTHORS; rm -f .authors.tmp) || (touch AUTHORS; echo 'git directory not found: installing possibly empty AUTHORS.' >&2)

targets: subdirs

subdirs:
	for dir in $(SUBDIRS); do \
		sed -e "s:\(VERSION=\).*:\1$(VERSION):g" \
			-e "s:\(bindir=\).*:\1$(bindir):g" \
			-e "s:\(libdir=\).*:\1$(libdir):g" \
			-e "s:\(sharedir=\).*:\1$(sharedir):g" \
			-e "s:\(INSTALL=\).*:\1$(INSTALL):g" \
			-e "s:\(MAKE=\).*:\1$(MAKE):g" \
			$$dir/Makefile.in > $$dir/Makefile; \
		$(MAKE) -C $$dir targets; \
	done

install:
	$(INSTALL) -d -m 755 $(DESTDIR)$(bindir)
	$(INSTALL) -d -m 755 $(DESTDIR)$(libdir)
	$(INSTALL) -d -m 755 $(DESTDIR)$(sharedir)
	$(INSTALL) -m 644 ChangeLog $(DESTDIR)$(sharedir)/ChangeLog
	$(INSTALL) -m 644 AUTHORS $(DESTDIR)$(sharedir)/AUTHORS
	$(INSTALL) -m 644 LICENSE $(DESTDIR)$(sharedir)/LICENSE
	$(MAKE) -C bin install
	$(MAKE) -C lib install
	$(MAKE) -C share install

clean: subdirs-clean
	rm -f ChangeLog
	rm -f AUTHORS

subdirs-clean:
	for dir in $(SUBDIRS); do \
		sed -e "s:\(VERSION=\).*:\1$(VERSION):g" \
			-e "s:\(bindir=\).*:\1$(bindir):g" \
			-e "s:\(libdir=\).*:\1$(libdir):g" \
			-e "s:\(sharedir=\).*:\1$(sharedir):g" \
			-e "s:\(INSTALL=\).*:\1$(INSTALL):g" \
			-e "s:\(MAKE=\).*:\1$(MAKE):g" \
			$$dir/Makefile.in > $$dir/Makefile; \
		$(MAKE) -C $$dir clean; \
		rm -f $$dir/Makefile; \
	done
