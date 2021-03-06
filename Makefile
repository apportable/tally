VERSION = 0.0.3
PREFIX  = /usr/local
BINDIR  = $(PREFIX)/bin
TALLY   = ./tally.lua

help:
	@echo "Usage:"
	@echo "   make install           Install to $(BINDIR)"
	@echo "   make install-home      Install to $(HOME)/.local/bin"
	@echo "   make dist              Create release tarball"
	@echo "   make clean             Remove generated files"

install-home: PREFIX = $(HOME)/.local

install install-home:
	mkdir -p $(DESTDIR)$(BINDIR)
	install -p -m 0755 $(TALLY) $(DESTDIR)$(BINDIR)/tally

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/tally

tally-%.tar.gz:
	git archive --prefix=tally-$*/ -o $@ $*

dist: tally-$(VERSION).tar.gz
dist-dev: tally-$(shell git rev-parse --verify --short master).tar.gz

clean:
	$(RM) tally-*.tar.gz


.PHONY: help install uninstall install-home dist dist-dev clean
