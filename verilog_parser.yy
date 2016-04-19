%skeleton "lalr1.cc"
%require  "3.0"
%debug 
%defines 
%define api.namespace {VL}
%define parser_class_name {VerilogParser}

%code requires{
   namespace VL {
      class VerilogDriver;
      class VerilogScanner;
   }
}

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
   std::string *sval;
   int         ival;
}

%token END    0     "end of file"
%token NEWLINE
%token UNKNOWN
%token CHAR
%token IDENTIFIER

%token DEFINE

%token COMMENT_LINE
%token COMMENT_BLOCK_BEGIN
%token COMMENT_BLOCK_END


/* destructor rule for <sval> objects */
%destructor { if ($$)  { delete ($$); ($$) = NULL; } } <sval>


%%
file            : COMMENT_LINE comment_content NEWLINE {driver.add_oneline_comment();}
                | COMMENT_BLOCK_BEGIN comment_content COMMENT_BLOCK_END

comment_content : string;

string          : CHAR string
                | CHAR
                | ;
%%


void VL::VerilogParser::error( const std::string &err_message )
{
   std::cerr << "Error: " << err_message << "\n"; 
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
