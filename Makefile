# -*- Makefile -*- for zlib

ifneq ($(findstring $(MAKEFLAGS),s),s)
ifndef V
        QUIET_CC       = @echo '   ' CC $@;
        QUIET_AR       = @echo '   ' AR $@;
        QUIET_RANLIB   = @echo '   ' RANLIB $@;
        QUIET_INSTALL  = @echo '   ' INSTALL $<;
        export V
endif
endif

LIB    = libz.a
AR    ?= ar
CC    ?= gcc
RANLIB?= ranlib
RM    ?= rm -f

prefix ?= /usr/local
libdir := $(prefix)/lib
includedir := $(prefix)/include

HEADERS = zlib.h zconf.h
SOURCES = adler32.c compress.c crc32.c gzio.c uncompr.c deflate.c trees.c \
          zutil.c inflate.c infback.c inftrees.c inffast.c

HEADERS_INST := $(patsubst %,$(includedir)/%,$(HEADERS))
OBJECTS := $(patsubst %.c,%.o,$(SOURCES))

CFLAGS ?= -O2

.PHONY: install

all: $(LIB)

$(includedir)/%.h: %.h
	-@if [ ! -d $(includedir)  ]; then mkdir -p $(includedir); fi
	$(QUIET_INSTALL)cp $< $@
	@chmod 0644 $@

$(libdir)/%.a: %.a
	-@if [ ! -d $(libdir)  ]; then mkdir -p $(libdir); fi
	$(QUIET_INSTALL)cp $< $@
	@chmod 0644 $@

install: $(HEADERS_INST) $(libdir)/$(LIB)

clean:
	$(RM) $(OBJECTS) $(LIB)

distclean: clean

$(LIB): $(OBJECTS)
	$(QUIET_AR)$(AR) rcu $@ $^
	$(QUIET_RANLIB)$(RANLIB) $@

%.o: %.c
	$(QUIET_CC)$(CC) $(CFLAGS) -o $@ -c $<
