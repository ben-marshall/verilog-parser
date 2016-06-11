## --------------------------------------------------------
## Compiler Variables
## --------------------------------------------------------

AR          = ar

AR_OPTS     = rcs

CC          = gcc

CC_OPTS     = -O0 -Wall

LOGFILE     = build.log


## --------------------------------------------------------
## FLEX Source, Output and Options
## --------------------------------------------------------

SCANNER_IN  = verilog_scanner.l

SCANNER_OUT = verilog_scanner.c

FLEX_OPTS   = "--yylineno"

## --------------------------------------------------------
## BISON Sources, Output and Options
## --------------------------------------------------------

PARSER_IN   = verilog_parser.y

PARSER_OUT  = verilog_parser.tab.c
PARSER_HEAD = verilog_parser.tab.h

BISON_OPTS  = "-d"

## --------------------------------------------------------
## C Code source
## --------------------------------------------------------

APP_SRC     = main.c

APP_OUT     = verilog-parser

LIB_OBJECTS = verilog_ast.c.o \
              verilog_ast_common.c.o \
              verilog_parser.c.o \
              $(SCANNER_OUT).o \
              $(PARSER_OUT).o

LIB_FILE    = libverilogparser.a

FLEX_SRC    = verilog_scanner.l

BISON_SRC   = verilog_scanner.y


## --------------------------------------------------------
## Auxiliary Rules and Actions
## --------------------------------------------------------

all: parser_lib parser_app

clean:
	rm -f $(PARSER_OUT) $(PARSER_HEAD) $(SCANNER_OUT) 
	rm -f *.output 
	rm -f *.out
	rm -f *.o

fromclean: clean all


## --------------------------------------------------------
## Compilation Rules and Actions
## --------------------------------------------------------

parser_app : parser scanner parser_lib
	$(CC)  $(CC_OPTS) -static $(APP_SRC) -L. -lverilogparser -o $(APP_OUT)

parser_lib : parser scanner $(LIB_OBJECTS)
	$(AR) $(AR_OPTS) $(LIB_FILE) $(LIB_OBJECTS)

%.c.o: %.c
	$(CC) $(CC_OPTS) -o $@ -c $< 

scanner: parser
	flex $(FLEX_OPTS) -o $(SCANNER_OUT) $(SCANNER_IN)

parser:
	bison $(BISON_OPTS) -o $(PARSER_OUT) $(PARSER_IN)



