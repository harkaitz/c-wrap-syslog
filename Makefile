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
	@echo "D $(PROGS) $(LIBRARIES)"
	@rm -f $(PROGS) $(LIBRARIES)
install:  $(LIBRARIES) ./l-wrap-syslog
	@echo "B $(PREFIX_TC)/bin/l-wrap-syslog"
	@$(SUDO_TC) mkdir -p $(DESTDIR)$(PREFIX_TC)/bin
	@$(SUDO_TC) cp l-wrap-syslog $(DESTDIR)$(PREFIX_TC)/bin
	@echo "I $(PREFIX)/lib/ $(LIBRARIES)"
	@mkdir -p $(DESTDIR)$(PREFIX)/lib
	@cp $(LIBRARIES) $(DESTDIR)$(PREFIX)/lib
## -- library and examples
libwrap-syslog.a: wrap-syslog.c
	@echo "B $@ $^"
	@$(CC) -c -o wrap-syslog.o $< $(CFLAGS) $(CPPFLAGS)
	@$(AR) -crs $@ wrap-syslog.o
	@rm -f wrap-syslog.o
example-w$(EXE): example.c libwrap-syslog.a
	@echo "B $@ $^"
	@$(CC) -o $@ $^ -L. `./l-wrap-syslog` $(CFLAGS) $(CPPFLAGS)
example-nw$(EXE): example.c libwrap-syslog.a
	@echo "B $@ $^"
	@$(CC) -o $@ $^ $(CFLAGS) $(CPPFLAGS)
## -- test
test: $(PROGS)
	@echo "==== NOT WRAPPED ========="
	@./example-nw
	@echo "==== WRAPPED ============="
	@./example-w
## -- license --
install: install-license
install-license: LICENSE
	mkdir -p $(DESTDIR)$(PREFIX)/share/doc/c-wrap-syslog
	cp LICENSE $(DESTDIR)$(PREFIX)/share/doc/c-wrap-syslog
## -- license --
