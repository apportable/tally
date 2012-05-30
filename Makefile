install: *_count stripcmt tally
	mkdir -p ~/.local/bin
	install -pm0755 $^ ~/.local/bin

.PHONY: install
