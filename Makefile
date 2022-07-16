DESTDIR    =
PREFIX     =/usr/local
CC         =gcc
CFLAGS     =-Wall
AR         =ar
PROGS      =example-w$(EXE) example-nw$(EXE)
LIBRARIES  =libwrap-syslog.a
CFLAGS_ALL =$(CFLAGS) $(CPPFLAGS)

## --------------------------------------------------------
all: $(PROGS) $(LIBRARIES)
clean:
	rm -f $(PROGS) $(LIBRARIES)
install:  $(LIBRARIES) ./l-wrap-syslog
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	mkdir -p $(DESTDIR)$(PREFIX)/lib
	cp l-wrap-syslog $(DESTDIR)$(PREFIX)/bin
	cp $(LIBRARIES) $(DESTDIR)$(PREFIX)/lib

## --------------------------------------------------------
libwrap-syslog.a: wrap-syslog.c
	$(CC) -c -o wrap-syslog.o $< $(CFLAGS_ALL) $(LIBS)
	$(AR) -crs $@ wrap-syslog.o
	rm -f wrap-syslog.o
example-w$(EXE): example.c libwrap-syslog.a
	$(CC) -o $@ $^ -L. `./l-wrap-syslog`
example-nw$(EXE): example.c libwrap-syslog.a
	$(CC) -o $@ $^

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
