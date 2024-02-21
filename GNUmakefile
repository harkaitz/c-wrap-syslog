PROJECT    =c-wrap-syslog
VERSION    =1.0.0
DESTDIR    =
PREFIX     =/usr/local
CC         =gcc -pedantic-errors -std=c99 -Wall
AR         =ar
PROGS      =example-w$(EXE) example-nw$(EXE)
LIBRARIES  =libwrap-syslog.a
##
all: $(PROGS) $(LIBRARIES)
clean:	
	rm -f $(PROGS) $(LIBRARIES)
install:
	@mkdir -p $(DESTDIR)$(if $(PREFIX_TC),$(PREFIX_TC),$(PREFIX))/bin
	@mkdir -p $(DESTDIR)$(PREFIX)/lib
	cp l-wrap-syslog $(DESTDIR)$(if $(PREFIX_TC),$(PREFIX_TC),$(PREFIX))/bin
	cp $(LIBRARIES) $(DESTDIR)$(PREFIX)/lib
##
libwrap-syslog.a: wrap-syslog.c
	$(CC) -c -o wrap-syslog.o $< $(CFLAGS) $(CPPFLAGS)
	$(AR) -crs $@ wrap-syslog.o
	rm -f wrap-syslog.o
example-w$(EXE): example.c libwrap-syslog.a
	$(CC) -o $@ $^ -L. `./l-wrap-syslog` $(CFLAGS) $(CPPFLAGS)
example-nw$(EXE): example.c libwrap-syslog.a
	$(CC) -o $@ $^ $(CFLAGS) $(CPPFLAGS)
##
test: $(PROGS)
	@echo "==== NOT WRAPPED ========="
	@./example-nw
	@echo "==== WRAPPED ============="
	@./example-w
## -- BLOCK:license --
install: install-license
install-license: 
	@mkdir -p $(DESTDIR)$(PREFIX)/share/doc/$(PROJECT)
	cp LICENSE  $(DESTDIR)$(PREFIX)/share/doc/$(PROJECT)
## -- BLOCK:license --
