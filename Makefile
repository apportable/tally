NAME    = tally
VERSION = 0.0.1
PREFIX  = /usr/local
BINDIR  = $(PREFIX)/bin
INSTALL = install -Dpm0755

install: tally.lua
	$(INSTALL) $< $(DESTDIR)$(BINDIR)/$(NAME)

uninstall:
	$(RM) $(DESTDIR)$(BINDIR)/$(NAME)

local-install:
	@$(MAKE) --no-print-directory install PREFIX=~/.local

dist: $(NAME)-$(VERSION).tar.gz

rpm: dist tally.spec ~makerpm
	cp $(NAME)-$(VERSION).tar.gz ~makerpm/rpmbuild/SOURCES
	cp tally.spec ~makerpm/rpmbuild/SPECS
	su -c 'cd ~/rpmbuild && rpmbuild -ba SPECS/tally.spec' makerpm
	cp ~makerpm/rpmbuild/RPMS/noarch/tally-$(VERSION)-*.noarch.rpm .

%.tar.gz: tally.lua Makefile README.md
	rm -rf $* $@
	mkdir $*
	cp $^ $*
	tar -czf $@ $*
	rm -rf $*

clean:
	$(RM) *.tar.gz *.rpm


.PHONY: install uninstall local-install dist rpm clean
