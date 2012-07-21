VERSION = 0.0.3
PREFIX  = /usr/local
BINDIR  = $(PREFIX)/bin

help:
	@echo "Usage:"
	@echo "   make instal            Install to PREFIX ($(PREFIX))"
	@echo "   make local-install     Install to $(HOME)/.local"
	@echo "   make dist              Create release tarball"
	@echo "   make check             Run tests"
	@echo "   make clean             Remove generated files"

install: tally
	install -Dpm0755 $< $(DESTDIR)$(BINDIR)/$<

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/tally

local-install:
	@$(MAKE) --no-print-directory install PREFIX=~/.local

dist:
	mkdir -p tally-$(VERSION)
	cp tally Makefile README.md tally-$(VERSION)
	tar -czf tally-$(VERSION).tar.gz tally-$(VERSION)
	rm -rf tally-$(VERSION)

check: test/expected.txt
	@./tally test | diff -su0 $< -
	@printf "\e[1;32mAll tests passed\e[0m\n"

clean:
	rm -f *.tar.gz


.PHONY: help install uninstall local-install dist check clean
