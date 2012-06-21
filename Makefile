VERSION = 0.0.3
PREFIX  = /usr/local
BINDIR  = $(PREFIX)/bin

install: tally
	install -Dpm0755 $< $(DESTDIR)$(BINDIR)/$<

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/tally

local-install:
	@$(MAKE) --no-print-directory install PREFIX=~/.local

rpm: dist tally.spec ~makerpm
	cp tally-$(VERSION).tar.gz ~makerpm/rpmbuild/SOURCES
	cp tally.spec ~makerpm/rpmbuild/SPECS
	su -c 'cd ~/rpmbuild && rpmbuild -ba SPECS/tally.spec' makerpm
	cp ~makerpm/rpmbuild/RPMS/noarch/tally-$(VERSION)-*.noarch.rpm .

dist:
	mkdir -p tally-$(VERSION)
	cp tally Makefile README.md tally-$(VERSION)
	tar -czf tally-$(VERSION).tar.gz tally-$(VERSION)
	rm -rf tally-$(VERSION)

clean:
	rm -f *.tar.gz *.rpm


.PHONY: install uninstall local-install dist rpm clean
