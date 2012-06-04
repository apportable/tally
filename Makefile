PREFIX  = /usr/local
INSTALL = install -Dpm0755

install: tally.lua
	$(INSTALL) $< $(DESTDIR)$(PREFIX)/bin/tally

uninstall:
	$(RM) $(DESTDIR)$(PREFIX)/bin/tally

local-install:
	@$(MAKE) --no-print-directory install PREFIX=~/.local


.PHONY: install uninstall local-install
