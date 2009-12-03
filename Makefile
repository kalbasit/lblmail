VERSION=0.1 

prefix=/usr/local
bindir=$(prefix)/bin
libdir=$(prefix)/lib/lblmail
sharedir=$(prefix)/share/lblmail
INSTALL=install
MAKE=make

all: dist targets;

dist: ChangeLog AUTHORS

ChangeLog:
	(GIT_DIR=.git git log > .changelog.tmp && mv .changelog.tmp ChangeLog; rm -f .changelog.tmp) || (touch ChangeLog; echo 'git directory not found: installing possibly empty changelog.' >&2)
	  
AUTHORS:
	(GIT_DIR=.git git log | grep ^Author | sort |uniq > .authors.tmp && mv .authors.tmp AUTHORS; rm -f .authors.tmp) || (touch AUTHORS; echo 'git directory not found: installing possibly empty AUTHORS.' >&2)

targets: make-bin-targets make-lib-targets make-share-targets

make-bin-targets:
	sed -e "s:\(VERSION=\).*:\1$(VERSION):g" \
		-e "s:\(bindir=\).*:\1$(bindir):g" \
		-e "s:\(libdir=\).*:\1$(libdir):g" \
		-e "s:\(sharedir=\).*:\1$(sharedir):g" \
		-e "s:\(INSTALL=\).*:\1$(INSTALL):g" \
		-e "s:\(MAKE=\).*:\1$(MAKE):g" \
		bin/Makefile.in > bin/Makefile
	$(MAKE) -C bin targets

make-lib-targets:
	sed -e "s:\(VERSION=\).*:\1$(VERSION):g" \
		-e "s:\(bindir=\).*:\1$(bindir):g" \
		-e "s:\(libdir=\).*:\1$(libdir):g" \
		-e "s:\(sharedir=\).*:\1$(sharedir):g" \
		-e "s:\(INSTALL=\).*:\1$(INSTALL):g" \
		-e "s:\(MAKE=\).*:\1$(MAKE):g" \
		lib/Makefile.in > lib/Makefile
	$(MAKE) -C lib targets

make-share-targets:
	sed -e "s:\(VERSION=\).*:\1$(VERSION):g" \
		-e "s:\(bindir=\).*:\1$(bindir):g" \
		-e "s:\(libdir=\).*:\1$(libdir):g" \
		-e "s:\(sharedir=\).*:\1$(sharedir):g" \
		-e "s:\(INSTALL=\).*:\1$(INSTALL):g" \
		-e "s:\(MAKE=\).*:\1$(MAKE):g" \
		share/Makefile.in > share/Makefile
	$(MAKE) -C share targets

install:
	$(INSTALL) -d -m 755 $(DESTDIR)$(bindir)
	$(INSTALL) -d -m 755 $(DESTDIR)$(libdir)
	$(INSTALL) -d -m 755 $(DESTDIR)$(sharedir)
	$(INSTALL) -m 644 ChangeLog $(DESTDIR)$(sharedir)/ChangeLog
	$(INSTALL) -m 644 AUTHORS $(DESTDIR)$(sharedir)/AUTHORS
	$(MAKE) -C bin install
	$(MAKE) -C lib install
	$(MAKE) -C share install

clean:
	sed -e "s:\(VERSION=\).*:\1$(VERSION):g" \
		-e "s:\(bindir=\).*:\1$(bindir):g" \
		-e "s:\(libdir=\).*:\1$(libdir):g" \
		-e "s:\(sharedir=\).*:\1$(sharedir):g" \
		-e "s:\(INSTALL=\).*:\1$(INSTALL):g" \
		-e "s:\(MAKE=\).*:\1$(MAKE):g" \
		bin/Makefile.in > bin/Makefile
	sed -e "s:\(VERSION=\).*:\1$(VERSION):g" \
		-e "s:\(bindir=\).*:\1$(bindir):g" \
		-e "s:\(libdir=\).*:\1$(libdir):g" \
		-e "s:\(sharedir=\).*:\1$(sharedir):g" \
		-e "s:\(INSTALL=\).*:\1$(INSTALL):g" \
		-e "s:\(MAKE=\).*:\1$(MAKE):g" \
		lib/Makefile.in > lib/Makefile
	sed -e "s:\(VERSION=\).*:\1$(VERSION):g" \
		-e "s:\(bindir=\).*:\1$(bindir):g" \
		-e "s:\(libdir=\).*:\1$(libdir):g" \
		-e "s:\(sharedir=\).*:\1$(sharedir):g" \
		-e "s:\(INSTALL=\).*:\1$(INSTALL):g" \
		-e "s:\(MAKE=\).*:\1$(MAKE):g" \
		share/Makefile.in > share/Makefile
	$(MAKE) -C bin clean
	$(MAKE) -C lib clean
	$(MAKE) -C share clean
	rm -f bin/Makefile
	rm -f lib/Makefile
	rm -f share/Makefile
