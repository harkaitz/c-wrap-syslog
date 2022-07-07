DESTDIR    =
PREFIX     =/usr/local
CC         =gcc
CFLAGS     =-Wall
CFLAGS_LIB =
AR         =ar
PROGS      =example-w example-nw
LIBRARIES  =libwrap-syslog.a

all: $(PROGS) $(LIBRARIES)
clean:
	rm -f $(PROGS) $(LIBRARIES)
install:  $(LIBRARIES) ./l-wrap-syslog
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	mkdir -p $(DESTDIR)$(PREFIX)/lib
	cp l-wrap-syslog $(DESTDIR)$(PREFIX)/bin
	cp $(LIBRARIES) $(DESTDIR)$(PREFIX)/lib

libwrap-syslog.a: wrap-syslog.c
	$(CC) -c -o wrap-syslog.o $< $(CFLAGS) $(CFLAGS_LIB)
	$(AR) -crs $@ wrap-syslog.o
	rm -f wrap-syslog.o

example-w: example.c libwrap-syslog.a
	$(CC) -o $@ $^ -L. `./l-wrap-syslog`
example-nw: example.c libwrap-syslog.a
	$(CC) -o $@ $^
test: $(PROGS)
	@echo "==== NOT WRAPPED ========="
	@./example-nw
	@echo "==== WRAPPED ============="
	@./example-w
