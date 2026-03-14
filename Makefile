.POSIX:
.PHONY: all install uninstall

VERSION = 0.1.0

ZIP_MAN ?= false

all: nvim-wrap nvim-send nvim-wrap.1

include config.mk

nvim-wrap:
	sed "s|@VERSION@|$(VERSION)|" nvim-wrap.sh > nvim-wrap
	chmod 755 nvim-wrap

nvim-send:
	sed "s|@VERSION@|$(VERSION)|" nvim-send.sh > nvim-send
	chmod 755 nvim-send

nvim-wrap.1:
	sed "s|@VERSION@|$(VERSION)|" nvim-wrap.1.in > nvim-wrap.1

install: all
	mkdir -p $(BIN_LOC)
	cp -vf nvim-wrap $(BIN_LOC)
	mkdir -p $(MANPREFIX)/man1
	@if [ "$(ZIP_MAN)" = "true" ]; then \
		echo "Installing compressed manpage..."; \
		gzip -c nvim-wrap.1 > nvim-wrap.1.gz; \
		cp -vf nvim-wrap.1.gz $(MANPREFIX)/man1/; \
	else \
		echo "Installing uncompressed manpage..."; \
		cp -vf nvim-wrap.1 $(MANPREFIX)/man1/; \
	fi
	cp -vf nvim-send $(BIN_LOC)
uninstall:
	rm -vf $(BIN_LOC)/nvim-wrap
	rm -vf $(BIN_LOC)/nvim-send
	rm -vf $(MANPREFIX)/man1/nvim-wrap.1*
clean:
	rm -vf nvim-wrap nvim-send nvim-wrap.1 nvim-wrap.1.gz
