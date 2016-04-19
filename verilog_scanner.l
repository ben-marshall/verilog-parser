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

CHAR                .
DIGIT               [0-9]
NUMBER              {DIGIT}+
NEWLINE             \n

COMMENT_LINE        "//"
COMMENT_BLOCK_BEGIN "/*"
COMMENT_BLOCK_END   "*/"

IDENTIFIER          [a-zA-Z0-9_]+

DEFINE              "`define"

%%
{COMMENT_LINE} {
    return token::COMMENT_LINE;
}
{COMMENT_BLOCK_BEGIN}  {
    return token::COMMENT_BLOCK_BEGIN;
}
{COMMENT_BLOCK_END}  {
    return token::COMMENT_BLOCK_END;
}


{NEWLINE}   { 
    return( token::NEWLINE );   
}

{CHAR}      {return token::CHAR;}
 %%
