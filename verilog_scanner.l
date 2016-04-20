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

ALWAYS              "always"
AND                 "and"
ASSIGN              "assign"
AUTOMATIC           "automatic"
BEGIN               "begin"
BUF                 "buf"
BUFIF0              "bufif0"
BUFIF1              "bufif1"
CASE                "case"
CASEX               "casex"
CASEZ               "casez"
CELL                "cell"
CMOS                "cmos"
CONFIG              "config"
DEASSIGN            "deassign"
DEFAULT             "default"
DEFPARAM            "defparam"
DESIGN              "design"
DISABLE             "disable"
EDGE                "edge"
ELSE                "else"
END                 "end"
ENDCASE             "endcase"
ENDCONFIG           "endconfig"
ENDFUNCTION         "endfunction"
ENDGENERATE         "endgenerate"
ENDMODULE           "endmodule"
ENDPRIMITIVE        "endprimitive"
ENDSPECIFY          "endspecify"
ENDTABLE            "endtable"
ENDTASK             "endtask"
EVENT               "event"
FOR                 "for"
FORCE               "force"
FOREVER             "forever"
FORK                "fork"
FUNCTION            "function"
GENERATE            "generate"
GENVAR              "genvar"
HIGHZ0              "highz0"
HIGHZ1              "highz1"
IF                  "if"
IFNONE              "ifnone"
INCDIR              "incdir"
INCLUDE             "include"
INITIAL             "initial"
INOUT               "inout"
INPUT               "input"
INSTANCE            "instance"
INTEGER             "integer"
JOIN                "join"
LARGE               "large"
LIBLIST             "liblist"
LIBRARY             "library"
LOCALPARAM          "localparam"
MACROMODULE         "macromodule"
MEDIUM              "medium"
MODULE              "module"
NAND                "nand"
NEGEDGE             "negedge"
NMOS                "nmos"
NOR                 "nor"
NOSHOWCANCELLED     "noshowcancelled"
NOT                 "not"
NOTIF0              "notif0"
NOTIF1              "notif1"
OR                  "or"
OUTPUT              "output"
PARAMETER           "parameter"
PMOS                "pmos"
POSEDGE             "posedge"
PRIMITIVE           "primitive"
PULL0               "pull0"
PULL1               "pull1"
PULLDOWN            "pulldown"
PULLUP              "pullup"
PULSESTYLE_ONEVENT  "pulsestyle_onevent"
PULSESTYLE_ONDETECT "pulsestyle_ondetect"
RCMOS               "rcmos"
REAL                "real"
REALTIME            "realtime"
REG                 "reg"
RELEASE             "release"
REPEAT              "repeat"
RNMOS               "rnmos"
RPMOS               "rpmos"
RTRAN               "rtran"
RTRANIF0            "rtranif0"
RTRANIF1            "rtranif1"
SCALARED            "scalared"
SHOWCANCELLED       "showcancelled"
SIGNED              "signed"
SMALL               "small"
SPECIFY             "specify"
SPECPARAM           "specparam"
STRONG0             "strong0"
STRONG1             "strong1"
SUPPLY0             "supply0"
SUPPLY1             "supply1"
TABLE               "table"
TASK                "task"
TIME                "time"
TRAN                "tran"
TRANIF0             "tranif0"
TRANIF1             "tranif1"
TRI                 "tri"
TRI0                "tri0"
TRI1                "tri1"
TRIAND              "triand"
TRIOR               "trior"
TRIREG              "trireg"
UNSIGNED            "unsigned"
USE                 "use"
VECTORED            "vectored"
WAIT                "wait"
WAND                "wand"
WEAK0               "weak0"
WEAK1               "weak1"
WHILE               "while"
WIRE                "wire"
WOR                 "wor"
XNOR                "xnor"
XOR                 "xor"

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
