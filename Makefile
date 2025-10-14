.POSIX:
PREFIX = ${HOME}/.local
.PHONY: all install uninstall

all: nvim-wrap nvim-send

nvim-wrap:
	cp nvim-wrap.sh nvim-wrap

nvim-send:
	cp nvim-send.sh nvim-send


install: all
	chmod 755 nvim-wrap
	chmod 755 nvim-send
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -vf nvim-wrap ${DESTDIR}${PREFIX}/bin
	cp -vf nvim-send ${DESTDIR}${PREFIX}/bin
uninstall:
	rm -vf ${DESTDIR}${PREFIX}/bin/nvim-wrap
	rm -vf ${DESTDIR}${PREFIX}/bin/nvim-send
clean:
	rm -vf nvim-wrap nvim-send

