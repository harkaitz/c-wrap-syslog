DESTDIR    =
PREFIX     =/usr/local
PREFIX_TC  =/usr/local
SUDO_TC    =sudo
CC         =gcc
CFLAGS     =-Wall
AR         =ar
PROGS      =example-w$(EXE) example-nw$(EXE)
LIBRARIES  =libwrap-syslog.a

## --------------------------------------------------------
all: $(PROGS) $(LIBRARIES)
clean:
	rm -f $(PROGS) $(LIBRARIES)
install:  $(LIBRARIES) ./l-wrap-syslog
	$(SUDO_TC) mkdir -p $(DESTDIR)$(PREFIX_TC)/bin
	$(SUDO_TC) cp l-wrap-syslog $(DESTDIR)$(PREFIX_TC)/bin
	mkdir -p $(DESTDIR)$(PREFIX)/lib
	cp $(LIBRARIES) $(DESTDIR)$(PREFIX)/lib

## --------------------------------------------------------
libwrap-syslog.a: wrap-syslog.c
	$(CC) -c -o wrap-syslog.o $< $(CFLAGS) $(CPPFLAGS)
	$(AR) -crs $@ wrap-syslog.o
	rm -f wrap-syslog.o
example-w$(EXE): example.c libwrap-syslog.a
	$(CC) -o $@ $^ -L. `./l-wrap-syslog` $(CFLAGS) $(CPPFLAGS)
example-nw$(EXE): example.c libwrap-syslog.a
	$(CC) -o $@ $^ $(CFLAGS) $(CPPFLAGS)

## --------------------------------------------------------
test: $(PROGS)
	@echo "==== NOT WRAPPED ========="
	@./example-nw
	@echo "==== WRAPPED ============="
	@./example-w

## -- license --
ifneq ($(PREFIX),)
install: install-license
install-license: LICENSE
	mkdir -p $(DESTDIR)$(PREFIX)/share/doc/c-wrap-syslog
	cp LICENSE $(DESTDIR)$(PREFIX)/share/doc/c-wrap-syslog
endif
## -- license --
