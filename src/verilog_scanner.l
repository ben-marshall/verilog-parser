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
#define yyterminate() return token::END;

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

%x in_str
%x in_comment
%x in_blk_comment
%x in_declaration

%x in_rval
%x in_rval_h
%x in_rval_o
%x in_rval_d
%x in_rval_b

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
INCDIR              "-incdir"
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

PATHPULSE           "PATHPULSE$"

SIMPLE_IDENTIFIER           ([a-zA-Z_][a-zA-Z0-9_\$]*)
SYSTEM_IDENTIFIER           (\$[a-zA-Z0-9_\$][a-zA-Z0-9_\$]*)

HEX_DIGIT                   [0-9a-fA-F]
OCTAL_DIGIT                 "0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"
BINARY_DIGIT                "0"|"1"
DECIMAL_DIGIT               "0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"

HEX_BASE                    [[sS][hH]]|[hH]
OCTAL_BASE                  [[sS][oO]]|[oO]
DECIMAL_BASE                [[sS][dD]]|[dD]
BINARY_BASE                 [[sS][bB]]|[bB]
EXP                         [eE]

OPEN_BRACKET                "("
CLOSE_BRACKET               ")"
OPEN_SQ_BRACKET             "["
CLOSE_SQ_BRACKET            "]"
STAR                        "*"
HASH                        "#"
DOT                         "."
SEMICOLON                   ";"
COLON                       ":"
EQ                          "="
COMMA                       ","
AT                          "@"

QM                          "?"
LT                          "<"
GT                          ">"
PLUS                        "+"  
MINUS                       "-"  
DIV                         "/"  
MOD                         "%"
L_NOT                       "!" 
B_NOT                       "~" 
B_AND                       "&" 
B_NAND                      "~&" 
B_OR                        "|" 
B_NOR                       "~|" 
B_XOR                       "^"               
B_XNOR_1                    "~^" 
B_XNOR_2                    "^~"

COMMENT_LINE                "//"
COMMENT_BEGIN               "/*"
COMMENT_END                 "*/"

CD_CELLDEFINE               "‘celldefine"
CD_DEFAULT_NETTYPE          "‘default_nettype"
CD_DEFINE                   "‘define"
CD_ELSE                     "‘else"
CD_ELSIF                    "‘elsif"
CD_ENDCELLDEFINE            "‘endcelldefine"
CD_ENDIF                    "‘endif"
CD_IFDEF                    "‘ifdef"
CD_IFNDEF                   "‘ifndef"
CD_INCLUDE                  "‘include"
CD_LINE                     "‘line"
CD_NOUNCONNECTED_DRIVE      "‘nounconnected_drive"
CD_RESETALL                 "‘resetall"
CD_TIMESCALE                "‘timescale"
CD_UNCONNECTED_DRIVE        "‘unconnected_drive"
CD_UNDEF                    "‘undef"

X_DIGIT                     [xX]
Z_DIGIT                     [zZ?]

NEWLINE             \n
TAB                 \t
SPACE               " "
ANY                 [.\n]{-}[' ']
ANY_IN_STR          .
STR_TERM                    \"

%%

{COMMENT_LINE}               {BEGIN(in_comment);return token::COMMENT_LINE;}
{COMMENT_BEGIN}              {
    BEGIN(in_blk_comment);
    return token::COMMENT_BEGIN;
}

<in_comment>.                {return token::ANY;                      ;}
<in_comment>\n               {BEGIN(INITIAL); return token::NEWLINE   ;}

<in_blk_comment>.            {return token::ANY;                      ;}
<in_blk_comment>\n           {return token::ANY;                      ;}
<in_blk_comment>{COMMENT_END} {BEGIN(INITIAL); return token::COMMENT_END ;}

{CD_CELLDEFINE}              {return token::CD_CELLDEFINE             ;}
{CD_DEFAULT_NETTYPE}         {return token::CD_DEFAULT_NETTYPE        ;}
{CD_DEFINE}                  {return token::CD_DEFINE                 ;}
{CD_ELSE}                    {return token::CD_ELSE                   ;}
{CD_ELSIF}                   {return token::CD_ELSIF                  ;}
{CD_ENDCELLDEFINE}           {return token::CD_ENDCELLDEFINE          ;}
{CD_ENDIF}                   {return token::CD_ENDIF                  ;}
{CD_IFDEF}                   {return token::CD_IFDEF                  ;}
{CD_IFNDEF}                  {return token::CD_IFNDEF                 ;}
{CD_INCLUDE}                 {return token::CD_INCLUDE                ;}
{CD_LINE}                    {return token::CD_LINE                   ;}
{CD_NOUNCONNECTED_DRIVE}     {return token::CD_NOUNCONNECTED_DRIVE    ;}
{CD_RESETALL}                {return token::CD_RESETALL               ;}
{CD_TIMESCALE}               {return token::CD_TIMESCALE              ;}
{CD_UNCONNECTED_DRIVE}       {return token::CD_UNCONNECTED_DRIVE      ;}
{CD_UNDEF}                   {return token::CD_UNDEF                  ;}

{EQ}                         {return token::EQ;}

{DECIMAL_DIGIT} {
                            return token::DECIMAL_DIGIT;
                            }

<in_rval>{HEX_BASE}          {BEGIN(in_rval_h);return token::HEX_BASE ;}
<in_rval>{OCTAL_BASE}        {BEGIN(in_rval_o);return token::OCTAL_BASE;}
<in_rval>{DECIMAL_BASE}      {BEGIN(in_rval_d);return token::DECIMAL_BASE;}
<in_rval>{BINARY_BASE}       {BEGIN(in_rval_b);return token::BINARY_BASE;}

<in_rval>s|S                 {return token::S                         ;}
<in_rval>{EXP}               {return token::EXP                       ;}
<in_rval_o>{OCTAL_DIGIT}       {return token::OCTAL_DIGIT               ;}
<in_rval_h>{HEX_DIGIT}         {return token::HEX_DIGIT                 ;}

{OPEN_BRACKET}               {return token::OPEN_BRACKET              ;}
{CLOSE_BRACKET}              {return token::CLOSE_BRACKET             ;}
{OPEN_SQ_BRACKET}            {return token::OPEN_SQ_BRACKET           ;}
{CLOSE_SQ_BRACKET}           {return token::CLOSE_SQ_BRACKET          ;}
{STAR}                       {return token::STAR                      ;}
{HASH}                       {return token::HASH     ;}
{DOT}                        {return token::DOT      ;}
{SEMICOLON}                  {BEGIN(INITIAL); return token::SEMICOLON;}
{COLON}                      {return token::COLON    ;}
{COMMA}                      {return token::COMMA;}
{AT}                         {return token::AT;}

{ALWAYS}               {return token::KW_ALWAYS             ;} 
{AND}                  {return token::KW_AND                ;} 
{ASSIGN}               {return token::KW_ASSIGN             ;} 
{AUTOMATIC}            {return token::KW_AUTOMATIC          ;} 
{BEGIN}                {return token::KW_BEGIN              ;} 
{BUF}                  {return token::KW_BUF                ;} 
{BUFIF0}               {return token::KW_BUFIF0             ;} 
{BUFIF1}               {return token::KW_BUFIF1             ;} 
{CASE}                 {return token::KW_CASE               ;} 
{CASEX}                {return token::KW_CASEX              ;} 
{CASEZ}                {return token::KW_CASEZ              ;} 
{CELL}                 {return token::KW_CELL               ;} 
{CMOS}                 {return token::KW_CMOS               ;} 
{CONFIG}               {return token::KW_CONFIG             ;} 
{DEASSIGN}             {return token::KW_DEASSIGN           ;} 
{DEFAULT}              {return token::KW_DEFAULT            ;} 
{DEFPARAM}             {return token::KW_DEFPARAM           ;} 
{DESIGN}               {return token::KW_DESIGN             ;} 
{DISABLE}              {return token::KW_DISABLE            ;} 
{EDGE}                 {return token::KW_EDGE               ;} 
{ELSE}                 {return token::KW_ELSE               ;} 
{END}                  {return token::KW_END                ;} 
{ENDCASE}              {return token::KW_ENDCASE            ;} 
{ENDCONFIG}            {return token::KW_ENDCONFIG          ;} 
{ENDFUNCTION}          {return token::KW_ENDFUNCTION        ;} 
{ENDGENERATE}          {return token::KW_ENDGENERATE        ;} 
{ENDMODULE}            {return token::KW_ENDMODULE          ;} 
{ENDPRIMITIVE}         {return token::KW_ENDPRIMITIVE       ;} 
{ENDSPECIFY}           {return token::KW_ENDSPECIFY         ;} 
{ENDTABLE}             {return token::KW_ENDTABLE           ;} 
{ENDTASK}              {return token::KW_ENDTASK            ;} 
{EVENT}                {return token::KW_EVENT              ;} 
{FOR}                  {return token::KW_FOR                ;} 
{FORCE}                {return token::KW_FORCE              ;} 
{FOREVER}              {return token::KW_FOREVER            ;} 
{FORK}                 {return token::KW_FORK               ;} 
{FUNCTION}             {return token::KW_FUNCTION           ;} 
{GENERATE}             {return token::KW_GENERATE           ;} 
{GENVAR}               {return token::KW_GENVAR             ;} 
{HIGHZ0}               {return token::KW_HIGHZ0             ;} 
{HIGHZ1}               {return token::KW_HIGHZ1             ;} 
{IF}                   {return token::KW_IF                 ;} 
{IFNONE}               {return token::KW_IFNONE             ;} 
{INCDIR}               {return token::KW_INCDIR             ;} 
{INCLUDE}              {return token::KW_INCLUDE            ;} 
{INITIAL}              {return token::KW_INITIAL            ;} 
{INOUT}                {return token::KW_INOUT              ;} 
{INPUT}                {return token::KW_INPUT              ;} 
{INSTANCE}             {return token::KW_INSTANCE           ;} 
{INTEGER}              {return token::KW_INTEGER            ;} 
{JOIN}                 {return token::KW_JOIN               ;} 
{LARGE}                {return token::KW_LARGE              ;} 
{LIBLIST}              {return token::KW_LIBLIST            ;} 
{LIBRARY}              {return token::KW_LIBRARY            ;} 
{LOCALPARAM}           {return token::KW_LOCALPARAM         ;} 
{MACROMODULE}          {return token::KW_MACROMODULE        ;} 
{MEDIUM}               {return token::KW_MEDIUM             ;} 
{MODULE}               {return token::KW_MODULE             ;} 
{NAND}                 {return token::KW_NAND               ;} 
{NEGEDGE}              {return token::KW_NEGEDGE            ;} 
{NMOS}                 {return token::KW_NMOS               ;} 
{NOR}                  {return token::KW_NOR                ;} 
{NOSHOWCANCELLED}      {return token::KW_NOSHOWCANCELLED    ;} 
{NOT}                  {return token::KW_NOT                ;} 
{NOTIF0}               {return token::KW_NOTIF0             ;} 
{NOTIF1}               {return token::KW_NOTIF1             ;} 
{OR}                   {return token::KW_OR                 ;} 
{OUTPUT}               {return token::KW_OUTPUT             ;} 
{PARAMETER}            {return token::KW_PARAMETER          ;} 
{PMOS}                 {return token::KW_PMOS               ;} 
{POSEDGE}              {return token::KW_POSEDGE            ;} 
{PRIMITIVE}            {return token::KW_PRIMITIVE          ;} 
{PULL0}                {return token::KW_PULL0              ;} 
{PULL1}                {return token::KW_PULL1              ;} 
{PULLDOWN}             {return token::KW_PULLDOWN           ;} 
{PULLUP}               {return token::KW_PULLUP             ;} 
{PULSESTYLE_ONEVENT}   {return token::KW_PULSESTYLE_ONEVENT ;} 
{PULSESTYLE_ONDETECT}  {return token::KW_PULSESTYLE_ONDETECT;} 
{RCMOS}                {return token::KW_RCMOS              ;} 
{REAL}                 {return token::KW_REAL               ;} 
{REALTIME}             {return token::KW_REALTIME           ;} 
{REG}                  {return token::KW_REG                ;} 
{RELEASE}              {return token::KW_RELEASE            ;} 
{REPEAT}               {return token::KW_REPEAT             ;} 
{RNMOS}                {return token::KW_RNMOS              ;} 
{RPMOS}                {return token::KW_RPMOS              ;} 
{RTRAN}                {return token::KW_RTRAN              ;} 
{RTRANIF0}             {return token::KW_RTRANIF0           ;} 
{RTRANIF1}             {return token::KW_RTRANIF1           ;} 
{SCALARED}             {return token::KW_SCALARED           ;} 
{SHOWCANCELLED}        {return token::KW_SHOWCANCELLED      ;} 
{SIGNED}               {return token::KW_SIGNED             ;} 
{SMALL}                {return token::KW_SMALL              ;} 
{SPECIFY}              {return token::KW_SPECIFY            ;} 
{SPECPARAM}            {return token::KW_SPECPARAM          ;} 
{STRONG0}              {return token::KW_STRONG0            ;} 
{STRONG1}              {return token::KW_STRONG1            ;} 
{SUPPLY0}              {return token::KW_SUPPLY0            ;} 
{SUPPLY1}              {return token::KW_SUPPLY1            ;} 
{TABLE}                {return token::KW_TABLE              ;} 
{TASK}                 {return token::KW_TASK               ;} 
{TIME}                 {return token::KW_TIME               ;} 
{TRAN}                 {return token::KW_TRAN               ;} 
{TRANIF0}              {return token::KW_TRANIF0            ;} 
{TRANIF1}              {return token::KW_TRANIF1            ;} 
{TRI}                  {return token::KW_TRI                ;} 
{TRI0}                 {return token::KW_TRI0               ;} 
{TRI1}                 {return token::KW_TRI1               ;} 
{TRIAND}               {return token::KW_TRIAND             ;} 
{TRIOR}                {return token::KW_TRIOR              ;} 
{TRIREG}               {return token::KW_TRIREG             ;} 
{UNSIGNED}             {return token::KW_UNSIGNED           ;} 
{USE}                  {return token::KW_USE                ;} 
{VECTORED}             {return token::KW_VECTORED           ;} 
{WAIT}                 {return token::KW_WAIT               ;} 
{WAND}                 {return token::KW_WAND               ;} 
{WEAK0}                {return token::KW_WEAK0              ;} 
{WEAK1}                {return token::KW_WEAK1              ;} 
{WHILE}                {return token::KW_WHILE              ;} 
{WIRE}                 {return token::KW_WIRE               ;} 
{WOR}                  {return token::KW_WOR                ;} 
{XNOR}                 {return token::KW_XNOR               ;} 
{XOR}                  {return token::KW_XOR                ;} 
{PATHPULSE}            {return token::KW_PATHPULSE          ;}

{QM}                   {return token::QM                    ;}
{LT}                   {return token::OP_LT                 ;}
{GT}                   {return token::OP_GT                 ;}
{PLUS}                 {return token::OP_PLUS               ;}
{MINUS}                {return token::OP_MINUS              ;}
{DIV}                  {return token::OP_DIV                ;}
{MOD}                  {return token::OP_MOD                ;}
{L_NOT}                {return token::OP_L_NOT              ;}
{B_NOT}                {return token::OP_B_NOT              ;}
{B_AND}                {return token::OP_B_AND              ;}
{B_NAND}               {return token::OP_B_NAND             ;}
{B_OR}                 {return token::OP_B_OR               ;}
{B_NOR}                {return token::OP_B_NOR              ;}
{B_XOR}                {return token::OP_B_XOR              ;}
{B_XNOR_1}             {return token::OP_B_XNOR_1           ;}
{B_XNOR_2}             {return token::OP_B_XNOR_2           ;}

{SYSTEM_IDENTIFIER}    {
    yylval->sval = strdup(yytext);
    return token::SYSTEM_IDENTIFIER;
}
{SIMPLE_IDENTIFIER}    {
    yylval->sval = strdup(yytext);
    return token::SIMPLE_IDENTIFIER;
}

{X_DIGIT}                    {return token::X_DIGIT                   ;}
{Z_DIGIT}                    {return token::Z_DIGIT                   ;}


<in_str>{STR_TERM}     {BEGIN(INITIAL);return token::STR_TERM;}
<in_str>{ANY_IN_STR}   {return token::ANY                   ;}
{STR_TERM}             {BEGIN(in_str);return token::STR_TERM;}

{NEWLINE}
{SPACE}                
{TAB}                  

{HEX_BASE}          {return token::HEX_BASE                  ;}
{OCTAL_BASE}        {return token::OCTAL_BASE                ;}
{DECIMAL_BASE}      {return token::DECIMAL_BASE              ;}
{BINARY_BASE}       {return token::BINARY_BASE               ;}

{ANY}                  {return token::ANY                   ;}
%%
