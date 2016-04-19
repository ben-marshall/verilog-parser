
all: prog

prog: bison flex
	g++ verilog_parser.tab.cc verilog_lexer.yy.c verilog_driver.cpp main.cpp

bison:
	bison -d verilog_parser.yy

flex: bison
	flex --outfile=verilog_lexer.yy.c verilog_scanner.l

clean:
	rm -f *.tab.c *.tab.h *.hh *.yy.c
