%{
/* C++ string header, for string ops below */
#include <string>
/* Implementation of yyFlexScanner */ 
#include "verilog_scanner.hpp"

/* typedef to make the returns for the tokens shorter */
typedef VL::VerilogParser::token token;

/* define to keep from re-typing the same code over and over */
#define STR_TOKEN( x ) ( new std::string( x ) )

/* define yyterminate as this instead of NULL */
#define yyterminate() return( token::END )

/* msvc2010 requires that we exclude this header file. */
#define YY_NO_UNISTD_H

%}

%option debug 
%option nodefault 
%option yyclass="VerilogScanner" 
%option noyywrap 
%option c++

DIGIT       [0-9]
NUMBER      {DIGIT}+
CHAR_LOWER  [a-z]
CHAR_UPPER  [A-Z]
IDENTIFIER  [a-zA-Z0-9]+

%%
{CHAR_LOWER} { 
    return( token::LOWER );     
}

{CHAR_UPPER}  { 
    return( token::UPPER );     
}

{IDENTIFIER} { 
    yylval->sval = STR_TOKEN( yytext );  
    return( token::WORD );      
}

\n          { 
    return( token::NEWLINE );   
}

.           { 
    return( token::CHAR );      
}
                                                                                                                                                                              %%
