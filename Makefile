.POSIX:
.PHONY: all install uninstall

all: nvim-wrap nvim-send

include config.mk

nvim-wrap:
	cp nvim-wrap.sh nvim-wrap

nvim-send:
	cp nvim-send.sh nvim-send


install: all
	chmod 755 nvim-wrap
	chmod 755 nvim-send
	mkdir -p $(BIN_LOC)
	cp -vf nvim-wrap $(BIN_LOC)
	cp -vf nvim-send $(BIN_LOC)
uninstall:
	rm -vf $(BIN_LOC)/nvim-wrap
	rm -vf $(BIN_LOC)/nvim-send
clean:
	rm -vf nvim-wrap nvim-send

