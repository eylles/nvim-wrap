.POSIX:
.PHONY: all install uninstall

VERSION = 0.0.0

all: nvim-wrap nvim-send

include config.mk

nvim-wrap:
	sed "s|@VERSION@|$(VERSION)|" nvim-wrap.sh > nvim-wrap
	chmod 755 nvim-wrap

nvim-send:
	sed "s|@VERSION@|$(VERSION)|" nvim-send.sh > nvim-send
	chmod 755 nvim-send


install: all
	mkdir -p $(BIN_LOC)
	cp -vf nvim-wrap $(BIN_LOC)
	cp -vf nvim-send $(BIN_LOC)
uninstall:
	rm -vf $(BIN_LOC)/nvim-wrap
	rm -vf $(BIN_LOC)/nvim-send
clean:
	rm -vf nvim-wrap nvim-send

