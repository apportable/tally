VERSION = 0.0.1
PREFIX  = /usr/local
BINDIR  = $(PREFIX)/bin

install: tally stripcmt
	mkdir -p $(DESTDIR)$(BINDIR)
	install -pm0755 $^ $(DESTDIR)$(BINDIR)

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/tally $(DESTDIR)$(BINDIR)/stripcmt

local-install:
	@$(MAKE) --no-print-directory install PREFIX=~/.local

dist: tally-$(VERSION).tar.gz

rpm: dist tally.spec ~makerpm
	cp tally-$(VERSION).tar.gz ~makerpm/rpmbuild/SOURCES
	cp tally.spec ~makerpm/rpmbuild/SPECS
	su -c 'cd ~/rpmbuild && rpmbuild -ba SPECS/tally.spec' makerpm
	cp ~makerpm/rpmbuild/RPMS/noarch/tally-$(VERSION)-*.noarch.rpm .

%.tar.gz: tally stripcmt Makefile README.md
	rm -rf $* $@
	mkdir $*
	cp $^ $*
	tar -czf $@ $*
	rm -rf $*

clean:
	rm -f *.tar.gz *.rpm


.PHONY: install uninstall local-install dist rpm clean
