VERSION=1.0

prefix=/usr/local
bindir=$(prefix)/bin
libdir=$(prefix)/lib
sharedir=$(prefix)/share
INSTALL=install
MAKE=make

all: targets;

targets: make-bin-targets make-lib-targets make-share-targets

make-bin-targets:
	sed -e "s:\(VERSION=\).*:\1$(VERSION):g" bin/Makefile.in > bin/Makefile
	$(MAKE) -C bin targets

make-lib-targets:
	sed -e "s:\(VERSION=\).*:\1$(VERSION):g" lib/Makefile.in > lib/Makefile
	$(MAKE) -C lib targets

make-share-targets:
	sed -e "s:\(VERSION=\).*:\1$(VERSION):g" share/Makefile.in > share/Makefile
	$(MAKE) -C share targets

install:
	$(INSTALL) -d -m 755 $(DESTDIR)$(bindir)
	$(INSTALL) -d -m 755 $(DESTDIR)$(libdir)
	$(INSTALL) -d -m 755 $(DESTDIR)$(libdir)/lblmail
	$(INSTALL) -d -m 755 $(DESTDIR)$(sharedir)
	$(INSTALL) -d -m 755 $(DESTDIR)$(sharedir)/lblmail
	$(MAKE) -C bin install
	$(MAKE) -C lib install
	$(MAKE) -C share install

clean:
	sed -e "s:\(VERSION=\).*:\1$(VERSION):g" bin/Makefile.in > bin/Makefile
	sed -e "s:\(VERSION=\).*:\1$(VERSION):g" lib/Makefile.in > lib/Makefile
	sed -e "s:\(VERSION=\).*:\1$(VERSION):g" share/Makefile.in > share/Makefile
	$(MAKE) -C bin clean
	$(MAKE) -C lib clean
	$(MAKE) -C share clean
	rm -f bin/Makefile
	rm -f lib/Makefile
	rm -f share/Makefile
