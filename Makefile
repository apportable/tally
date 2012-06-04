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

%.tar.gz: tally.lua Makefile README.md
	rm -rf $* $@
	mkdir $*
	cp $^ $*
	tar -czf $@ $*
	rm -rf $*


.PHONY: install uninstall local-install
