VERSION = 0.0.3
PREFIX  = /usr/local
BINDIR  = $(PREFIX)/bin
SCRIPT  = tally.sh

help:
	@echo "Usage:"
	@echo "   make instal            Install to PREFIX ($(PREFIX))"
	@echo "   make local-install     Install to $(HOME)/.local"
	@echo "   make dist              Create release tarball"
	@echo "   make check             Run tests"
	@echo "   make clean             Remove generated files"

install:
	install -Dpm0755 $(SCRIPT) $(DESTDIR)$(BINDIR)/tally

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/tally

local-install:
	@$(MAKE) --no-print-directory install PREFIX=~/.local

dist:
	mkdir -p tally-$(VERSION)
	cp -r tally.sh tally.lua Makefile README.md test/ tally-$(VERSION)
	tar -czf tally-$(VERSION).tar.gz tally-$(VERSION)
	rm -rf tally-$(VERSION)

check: test/expected.txt
	@./$(SCRIPT) test | diff -su0 $< -
	@printf "\e[1;32mAll tests passed\e[0m\n"

benchmark:
	@echo -n 'tally.lua: '
	@time -f '%es' ./tally.lua >/dev/null
	@echo -n 'tally.sh:  '
	@time -f '%es' ./tally.sh >/dev/null

clean:
	rm -f *.tar.gz


.PHONY: help install uninstall local-install dist check benchmark clean
