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

%option yylineno
%option debug 
%option nodefault 
%option yyclass="VerilogScanner" 
%option noyywrap 
%option c++

%x BLOCK_COMMENT
%x LINE_COMMENT

NEWLINE             \n
TAB                 \t
SPACE               " "

COMMENT_LINE        "//"
COMMENT_BEGIN       "/*"
COMMENT_END         "*/"

%%

<INITIAL>{COMMENT_BEGIN}     {BEGIN(BLOCK_COMMENT);}
<BLOCK_COMMENT>{COMMENT_END} {BEGIN(INITIAL); return token::COMMENT_BLOCK;}
<BLOCK_COMMENT>[^*\n]+       {}
<BLOCK_COMMENT>"*"           {}
<BLOCK_COMMENT>\n            {yylineno++;}

<INITIAL>{COMMENT_LINE}      {BEGIN(LINE_COMMENT);}
<LINE_COMMENT>.*{NEWLINE}    {BEGIN(INITIAL);return token::COMMENT_LINE;}

{NEWLINE} {return token::WS;}
{SPACE}   {return token::WS;}
{TAB}     {return token::WS;}
%%
