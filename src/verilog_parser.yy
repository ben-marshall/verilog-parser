%skeleton "lalr1.cc"
%require  "3.0"
%defines 
%define parse.trace
%verbose
%define api.namespace {VL}
%define parser_class_name {VerilogParser}

%code requires{
   namespace VL {
      class VerilogDriver;
      class VerilogScanner;
   }
}

%define parse.error verbose

%lex-param   { VerilogScanner  &scanner  }
%parse-param { VerilogScanner  &scanner  }

%lex-param   { VerilogDriver  &driver  }
%parse-param { VerilogDriver  &driver  }

%code{
   #include <iostream>
   #include <cstdlib>
   #include <fstream>
   
   /* include for all driver functions */
   #include "verilog_driver.hpp"
  
   /* this is silly, but I can't figure out a way around */
   static int yylex(VL::VerilogParser::semantic_type *yylval,
                    VL::VerilogScanner  &scanner,
                    VL::VerilogDriver   &driver);
}


/* token types */
%union {
   char * sval;
   int    ival;
}

%token END
%token NEWLINE
%token SPACE
%token TAB

%token AT
%token COMMA
%token HASH               
%token DOT                
%token EQ
%token COLON              
%token SEMICOLON          
%token OPEN_BRACKET       
%token CLOSE_BRACKET      
%token OPEN_SQ_BRACKET    
%token CLOSE_SQ_BRACKET   
%token OPEN_SQ_BRACE      
%token CLOSE_SQ_BRACE     

%token NUMBER
%token UNSIGNED_NUMBER

%token SYSTEM_ID
%token SIMPLE_ID
%token DEFINE_ID

%token ATTRIBUTE_START
%token ATTRIBUTE_END

%token COMMENT_LINE
%token COMMENT_BLOCK

%token STRING

%token PLUS
%token MINUS
%token ASL     
%token ASR     
%token LSL     
%token LSR     
%token DIV     
%token POW     
%token MOD     
%token GTE     
%token LTE     
%token GT      
%token LT      
%token L_NEG   
%token L_AND   
%token L_OR    
%token C_EQ    
%token L_EQ    
%token C_NEQ   
%token L_NEQ   
%token B_NEG   
%token B_AND   
%token B_OR    
%token B_XOR   
%token B_EQU   
%token B_NAND  
%token B_NOR   
%token TERNARY 

%token CD_CELLDEFINE
%token CD_DEFAULT_NETTYPE
%token CD_DEFINE
%token CD_ELSE
%token CD_ELSIF
%token CD_ENDCELLDEFINE
%token CD_ENDIF
%token CD_IFDEF
%token CD_IFNDEF
%token CD_INCLUDE
%token CD_LINE
%token CD_NOUNCONNECTED_DRIVE
%token CD_RESETALL
%token CD_TIMESCALE
%token CD_UNCONNECTED_DRIVE
%token CD_UNDEF

%token KW_ALWAYS
%token KW_AND
%token KW_ASSIGN
%token KW_AUTOMATIC
%token KW_BEGIN
%token KW_BUF
%token KW_BUFIF0
%token KW_BUFIF1
%token KW_CASE
%token KW_CASEX
%token KW_CASEZ
%token KW_CELL
%token KW_CMOS
%token KW_CONFIG
%token KW_DEASSIGN
%token KW_DEFAULT
%token KW_DEFPARAM
%token KW_DESIGN
%token KW_DISABLE
%token KW_EDGE
%token KW_ELSE
%token KW_END
%token KW_ENDCASE
%token KW_ENDCONFIG
%token KW_ENDFUNCTION
%token KW_ENDGENERATE
%token KW_ENDMODULE
%token KW_ENDPRIMITIVE
%token KW_ENDSPECIFY
%token KW_ENDTABLE
%token KW_ENDTASK
%token KW_EVENT
%token KW_FOR
%token KW_FORCE
%token KW_FOREVER
%token KW_FORK
%token KW_FUNCTION
%token KW_GENERATE
%token KW_GENVAR
%token KW_HIGHZ0
%token KW_HIGHZ1
%token KW_IF
%token KW_IFNONE
%token KW_INCDIR
%token KW_INCLUDE
%token KW_INITIAL
%token KW_INOUT
%token KW_INPUT
%token KW_INSTANCE
%token KW_INTEGER
%token KW_JOIN
%token KW_LARGE
%token KW_LIBLIST
%token KW_LIBRARY
%token KW_LOCALPARAM
%token KW_MACROMODULE
%token KW_MEDIUM
%token KW_MODULE
%token KW_NAND
%token KW_NEGEDGE
%token KW_NMOS
%token KW_NOR
%token KW_NOSHOWCANCELLED
%token KW_NOT
%token KW_NOTIF0
%token KW_NOTIF1
%token KW_OR
%token KW_OUTPUT
%token KW_PARAMETER
%token KW_PMOS
%token KW_POSEDGE
%token KW_PRIMITIVE
%token KW_PULL0
%token KW_PULL1
%token KW_PULLDOWN
%token KW_PULLUP
%token KW_PULSESTYLE_ONEVENT
%token KW_PULSESTYLE_ONDETECT
%token KW_RCMOS
%token KW_REAL
%token KW_REALTIME
%token KW_REG
%token KW_RELEASE
%token KW_REPEAT
%token KW_RNMOS
%token KW_RPMOS
%token KW_RTRAN
%token KW_RTRANIF0
%token KW_RTRANIF1
%token KW_SCALARED
%token KW_SHOWCANCELLED
%token KW_SIGNED
%token KW_SMALL
%token KW_SPECIFY
%token KW_SPECPARAM
%token KW_STRONG0
%token KW_STRONG1
%token KW_SUPPLY0
%token KW_SUPPLY1
%token KW_TABLE
%token KW_TASK
%token KW_TIME
%token KW_TRAN
%token KW_TRANIF0
%token KW_TRANIF1
%token KW_TRI
%token KW_TRI0
%token KW_TRI1
%token KW_TRIAND
%token KW_TRIOR
%token KW_TRIREG
%token KW_UNSIGNED
%token KW_USE
%token KW_VECTORED
%token KW_WAIT
%token KW_WAND
%token KW_WEAK0
%token KW_WEAK1
%token KW_WHILE
%token KW_WIRE
%token KW_WOR
%token KW_XNOR
%token KW_XOR

%start grammar_begin

%%

/* Start variables */

grammar_begin : 
              ;


/* A.1.1 Library Source Text */

library_text : library_descriptions_s
             ;

library_descriptions_s :
                       | library_descriptions
                       | library_descriptions_s library_descriptions

library_descriptions : library_declaration
                     | include_statement
                     | config_declaration
                     ;

library_declaration : KW_LIBRARY library_identifier 
                      file_path_spec_s
                      SEMICOLON
                    | KW_LIBRARY library_identifier 
                      file_path_spec_s
                      KW_INCDIR file_path_spec_s
                      SEMICOLON
                    ;

file_path_spec_s : file_path_spec
                 | file_path_spec_p file_path_spec
                 ;

file_path_spec : file_path
               ;

include_statement : KW_INCLUDE file_path_spec SEMICOLON
                  ;
   
/* A.1.2 Configuration Source Text */

config_declaration : KW_CONFIG config_identifier SEMICOLON
                     design_statement
                     config_rule_statement_os
                     KW_ENDCONFIG
                   ;

design_statement : design lib_cell_identifier_os SEMICOLON
                 ;

lib_cell_identifier_os :
                       | cell_identifier
                       | library_identifier DOT cell_identifier
                       | lib_cell_identifier_os cell_identifier
                       | lib_cell_identifier_os library_identifier DOT 
                         cell_identifier
                       ;

config_rule_statement_os :
                         | config_rule_statement
                         | config_rule_statement_os config_rule_statement
                         ;

config_rule_statement : default_clause liblist_clause
                      | inst_clause liblist_clause
                      | inst_clause use_clause
                      | cell_clause liblist_clause
                      | cell_clause use_clause
                      ;

default_clause  : KW_DEFAULT
                ;

inst_clause : KW_INSTANCE inst_name
            ;

inst_name   : topmodule_identifier instance_identifier_os
            ;

instance_identifier_os  :
                        | DOT instance_identifier
                        | instance_identifier_os DOT instance_identifier
                        ;

cell_clause : KW_CELL cell_identifier
            | KW_CELL library_identifier DOT cell_identifier
            ;

liblist_clause  : KW_LIBLIST library_identifier_os
                ;

library_identifier_os : 
                      | library_identifier
                      | library_identifier_os library_identifier
                      ;

use_clause : KW_USE library_identifier DOT cell_identifier COLON KW_CONFIG
           | KW_USE library_identifier DOT cell_identifier
           | KW_USE cell_identifier COLON KW_CONFIG
           | KW_USE cell_identifier
           ;

/* A.1.3 Module and primitive source text. */

source_text : description_os
            ;

description_os : 
               | description
               | description_os description
               ;

description : module_declaration
            | udp_declaration
            ;

module_declaration : attribute_instance_os
                     module_keyword
                     module_identifier
                     module_parameter_port_list_o
                     list_of_ports_o
                     SEMICOLON
                     module_item_os
                     KW_ENDMODULE
                   | attribute_instance_os
                     module_keyword
                     module_identifier
                     module_parameter_port_list_o
                     list_of_port_declarations_o
                     SEMICOLON
                     non_port_module_item_os
                     KW_ENDMODULE
                   ;

module_keyword     : KW_MODULE
                   | KW_MACROMODULE
                   ;

%%


void VL::VerilogParser::error( const std::string &err_message )
{
    std::cerr << "Line " << this->scanner.lineno() << ": ";
    std::cerr << "Parser Error: " << err_message << "\n"; 
    std::cerr << "\t" << this -> scanner.YYText()<<"\n";
}


/* include for access to scanner.yylex */
#include "verilog_scanner.hpp"
static int 
yylex( VL::VerilogParser::semantic_type *yylval,
       VL::VerilogScanner  &scanner,
       VL::VerilogDriver   &driver )
{
   return( scanner.yylex(yylval) );
}
