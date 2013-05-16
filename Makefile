VERSION = 0.0.3
PREFIX  = /usr/local
BINDIR  = $(PREFIX)/bin
TALLY   = ./tally.bash

help:
	@echo "Usage:"
	@echo "   make install           Install to PREFIX ($(PREFIX))"
	@echo "   make install-home      Install to $(HOME)/.local"
	@echo "   make dist              Create release tarball"
	@echo "   make check             Run tests"
	@echo "   make clean             Remove generated files"

install:
	install -Dpm0755 $(TALLY) $(DESTDIR)$(BINDIR)/tally

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/tally

install-home:
	@$(MAKE) --no-print-directory install PREFIX=~/.local

dist:
	mkdir -p tally-$(VERSION)
	cp -r tally.bash tally.lua Makefile README.md test/ tally-$(VERSION)
	tar -czf tally-$(VERSION).tar.gz tally-$(VERSION)
	rm -rf tally-$(VERSION)

check: test/expected.txt
	@$(TALLY) test | diff -su0 $< -
	@printf "\e[1;32mAll tests passed\e[0m\n"

benchmark:
	@echo -n 'tally.lua: '
	@time -f '%es' ./tally.lua >/dev/null
	@echo -n 'tally.bash:  '
	@time -f '%es' ./tally.bash >/dev/null

clean:
	rm -f *.tar.gz


.PHONY: help install uninstall install-home dist check benchmark clean
