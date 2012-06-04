PREFIX  = ~/.local
INSTALL = install -Dpm0755

install: tally.lua
	$(INSTALL) $< $(DESTDIR)$(PREFIX)/bin/tally

uninstall:
	$(RM) $(DESTDIR)$(PREFIX)/bin/tally


.PHONY: install uninstall
