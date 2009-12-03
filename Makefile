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
