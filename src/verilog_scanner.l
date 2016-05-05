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

/* Pre-processor definitions */
CD_CELLDEFINE          "`celldefine"
CD_DEFAULT_NETTYPE     "`default_nettype"
CD_DEFINE              "`define"
CD_ELSE                "`else"
CD_ELSIF               "`elsif"
CD_ENDCELLDEFINE       "`endcelldefine"
CD_ENDIF               "`endif"
CD_IFDEF               "`ifdef"
CD_IFNDEF              "`ifndef"
CD_INCLUDE             "`include"
CD_LINE                "`line"
CD_NOUNCONNECTED_DRIVE "`nounconnected_drive"
CD_RESETALL            "`resetall"
CD_TIMESCALE           "`timescale"
CD_UNCONNECTED_DRIVE   "`unconnected_drive"
CD_UNDEF               "`undef"

/* Keyword Token deffinitions. */
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

/* Single character tokens */

NEWLINE             "\n"|"\r\n"
SPACE               " "
TAB                 "\t"

AT                  "@"
COMMA               ","
HASH                "#"
DOT                 "."
EQ                  "="
COLON               ":"
SEMICOLON           ";"
OPEN_BRACKET        "\("
CLOSE_BRACKET       "\)"
OPEN_SQ_BRACKET     "\["
CLOSE_SQ_BRACKET    "\]"
OPEN_SQ_BRACE       "{"
CLOSE_SQ_BRACE      "}"


/* Tokens related to numbers */

EXP                 "e"|"E"
UNDERSCORE          "_"
SIGN                {PLUS}|{MINUS}
X                   "x"|"X"
Z                   "z"|"Z"

DIGIT_DECIMAL       [0-9]
DIGIT_DECMIAL_NZ    [1-9]
DIGIT_BINARY        [0-1]|{X}|{Z}
DIGIT_OCTAL         [0-7]
DIGIT_HEX           [0-9a-fA-F]

BASE_DECIMAL        '[sS]?[dD]
BASE_BINARY         '[s|S]?[b|B]
BASE_OCTAL          '[sS]?[oO]
BASE_HEX            '[sS]?[hH]

SIZE                {DIGIT_DECMIAL_NZ}+

UNSIGNED_NUM        {DIGIT_DECIMAL}({UNDERSCORE}|{DIGIT_DECIMAL})*
NUM_REAL_EXP        {UNSIGNED_NUM}({DOT}{UNSIGNED_NUM})?{EXP}({SIGN})?{UNSIGNED_NUM}
NUM_REAL            {UNSIGNED_NUM}{DOT}{UNSIGNED_NUM}|{NUM_REAL_EXP}

BIN_VALUE           {DIGIT_BINARY}({UNDERSCORE}|{DIGIT_BINARY})*
OCT_VALUE           {DIGIT_OCTAL}({UNDERSCORE}|{DIGIT_OCTAL})*
HEX_VALUE           {DIGIT_HEX}({UNDERSCORE}|{DIGIT_HEX})*

NUM_BINARY          {SIZE}?{BASE_BINARY}{BIN_VALUE}
NUM_OCTAL           {SIZE}?{BASE_OCTAL}{OCT_VALUE}
NUM_HEX             {SIZE}?{BASE_HEX}{HEX_VALUE}
NUM_DECIMAL         {SIZE}?{BASE_DECIMAL}{UNSIGNED_NUM}

NUMBER              {NUM_BINARY}|{NUM_HEX}|{NUM_OCTAL}|{NUM_REAL}|{NUM_DECIMAL}

/* Identifiers */

SYSTEM_ID           \$[a-zA-Z0-9_\$]+
SIMPLE_ID           [a-zA-Z_][a-zA-Z0-9_$]*
DEFINE_ID           `{SIMPLE_ID}

/* Attributes */

ATTRIBUTE_START     \(\*
ATTRIBUTE_END       \*\)

/* Comments */
COMMENT_LINE        "//".*\n
COMMENT_BLOCK       "/"\*[.\n]*\*"/"

/* Strings */

STRING              \".*\"

/* Operators */

STAR                "\*"
PLUS                "+"
MINUS               "-"
ASL                 "<<<"
ASR                 ">>>"
LSL                 "<<"
LSR                 ">>"
DIV                 "/"
POW                 "**"
MOD                 "%"
GTE                 ">="
LTE                 "<="
GT                  ">"
LT                  "<"
L_NEG               "!"
L_AND               "&&"
L_OR                "||"
C_EQ                "==="
L_EQ                "=="
C_NEQ               "!=="
L_NEQ               "!="
B_NEG               "~"
B_AND               "&"
B_OR                "|"
B_XOR               "^"
B_EQU               "^~"|"~^"
B_NAND              "~&"
B_NOR               "~|"
TERNARY             "?"

%%

{CD_CELLDEFINE}          {return token::CD_CELLDEFINE         ;}
{CD_DEFAULT_NETTYPE}     {return token::CD_DEFAULT_NETTYPE    ;}
{CD_DEFINE}              {return token::CD_DEFINE             ;}
{CD_ELSE}                {return token::CD_ELSE               ;}
{CD_ELSIF}               {return token::CD_ELSIF              ;}
{CD_ENDCELLDEFINE}       {return token::CD_ENDCELLDEFINE      ;}
{CD_ENDIF}               {return token::CD_ENDIF              ;}
{CD_IFDEF}               {return token::CD_IFDEF              ;}
{CD_IFNDEF}              {return token::CD_IFNDEF             ;}
{CD_INCLUDE}             {return token::CD_INCLUDE            ;}
{CD_LINE}                {return token::CD_LINE               ;}
{CD_NOUNCONNECTED_DRIVE} {return token::CD_NOUNCONNECTED_DRIVE;}
{CD_RESETALL}            {return token::CD_RESETALL           ;}
{CD_TIMESCALE}           {return token::CD_TIMESCALE          ;}
{CD_UNCONNECTED_DRIVE}   {return token::CD_UNCONNECTED_DRIVE  ;}
{CD_UNDEF}               {return token::CD_UNDEF              ;}

{COMMENT_LINE}         {/*return token::COMMENT_LINE;  IGNORE */}
{COMMENT_BLOCK}        {/*return token::COMMENT_BLOCK; IGNORE */}

{STRING}               {return token::STRING;                 }

{NEWLINE}              {/*return token::NEWLINE; IGNORE */   }
{SPACE}                {/*return token::SPACE;   IGNORE */   }
{TAB}                  {/*return token::TAB;     IGNORE */   }

{AT}                   {return token::AT                    ;}
{COMMA}                {return token::COMMA                 ;}
{HASH}                 {return token::HASH                  ;}
{DOT}                  {return token::DOT                   ;}
{EQ}                   {return token::EQ                    ;}
{COLON}                {return token::COLON                 ;}
{SEMICOLON}            {return token::SEMICOLON             ;}
{OPEN_BRACKET}         {return token::OPEN_BRACKET          ;}
{CLOSE_BRACKET}        {return token::CLOSE_BRACKET         ;}
{OPEN_SQ_BRACKET}      {return token::OPEN_SQ_BRACKET       ;}
{CLOSE_SQ_BRACKET}     {return token::CLOSE_SQ_BRACKET      ;}
{OPEN_SQ_BRACE}        {return token::OPEN_SQ_BRACE         ;}
{CLOSE_SQ_BRACE}       {return token::CLOSE_SQ_BRACE        ;}
{STAR}                 {return token::STAR                  ;}
{PLUS}                 {return token::PLUS                ;}
{MINUS}                {return token::MINUS               ;}
{ASL}                  {return token::ASL                 ;}
{ASR}                  {return token::ASR                 ;}
{LSL}                  {return token::LSL                 ;}
{LSR}                  {return token::LSR                 ;}
{DIV}                  {return token::DIV                 ;}
{POW}                  {return token::POW                 ;}
{MOD}                  {return token::MOD                 ;}
{GTE}                  {return token::GTE                 ;}
{LTE}                  {return token::LTE                 ;}
{GT}                   {return token::GT                  ;}
{LT}                   {return token::LT                  ;}
{L_NEG}                {return token::L_NEG               ;}
{L_AND}                {return token::L_AND               ;}
{L_OR}                 {return token::L_OR                ;}
{C_EQ}                 {return token::C_EQ                ;}
{L_EQ}                 {return token::L_EQ                ;}
{C_NEQ}                {return token::C_NEQ               ;}
{L_NEQ}                {return token::L_NEQ               ;}
{B_NEG}                {return token::B_NEG               ;}
{B_AND}                {return token::B_AND               ;}
{B_OR}                 {return token::B_OR                ;}
{B_XOR}                {return token::B_XOR               ;}
{B_EQU}                {return token::B_EQU               ;}
{B_NAND}               {return token::B_NAND              ;}
{B_NOR}                {return token::B_NOR               ;}
{TERNARY}              {return token::TERNARY             ;}

{NUMBER}               {return token::NUMBER;}
{UNSIGNED_NUM}         {return token::UNSIGNED_NUMBER;}

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

{SYSTEM_ID}            {return token::SYSTEM_ID             ;}
{SIMPLE_ID}            {return token::SIMPLE_ID             ;}
{DEFINE_ID}            {return token ::DEFINE_ID            ;}

{ATTRIBUTE_START}      {return token::ATTRIBUTE_START       ;}
{ATTRIBUTE_END}        {return token::ATTRIBUTE_END         ;}

.                      {return token::ANY                   ;}

%%
