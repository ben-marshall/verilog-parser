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

%x IN_BLOCK_COMMENT
%x IN_LINE_COMMENT
%x IN_DEFINE

NEWLINE             \n
TAB                 \t
SPACE               " "

COMMENT_LINE        "//"
COMMENT_BEGIN       "/*"
COMMENT_END         "*/"

IDENTIFIER          [a-zA-Z0-9_]+
VALUE               .+

DEFINE              "`define"

%%

<INITIAL>{DEFINE}        {BEGIN(IN_DEFINE);return token::DEFINE;}
<IN_DEFINE>[^*\n]+       {}
<IN_DEFINE>"*"           {}
<IN_DEFINE>\\\n          {}
<IN_DEFINE>\n            {BEGIN(INITIAL);return token::END_DEFINE;}

<INITIAL>{COMMENT_BEGIN}        {BEGIN(IN_BLOCK_COMMENT);}
<IN_BLOCK_COMMENT>{COMMENT_END} {BEGIN(INITIAL); return token::COMMENT_BLOCK;}
<IN_BLOCK_COMMENT>[^*\n]+       {}
<IN_BLOCK_COMMENT>"*"           {}
<IN_BLOCK_COMMENT>\n            {}

<INITIAL>{COMMENT_LINE}         {BEGIN(IN_LINE_COMMENT);}
<IN_LINE_COMMENT>.*{NEWLINE}    {BEGIN(INITIAL);return token::COMMENT_LINE;}

{NEWLINE} {return token::WS;}
{SPACE}   {return token::WS;}
{TAB}     {return token::WS;}
%%
