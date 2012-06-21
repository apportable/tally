VERSION = 0.0.2
PREFIX  = /usr/local
BINDIR  = $(PREFIX)/bin

install: tally
	install -Dpm0755 $< $(DESTDIR)$(BINDIR)/$<

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/tally

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
