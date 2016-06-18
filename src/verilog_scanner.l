%{
    #include "verilog_ast.h"
    #include "verilog_parser.tab.h"
%}

%option yylineno
%option nodefault 
%option noyywrap 

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
IDX_PRT_SEL         "+:"|"-:"
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
Z                   "z"|"Z"|"?"

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
MACRO_IDENTIFIER    `{SIMPLE_ID}

MACRO_TEXT          .*\n

%x in_define
%x in_define_t

/* Attributes */

ATTRIBUTE_START     \(\*
ATTRIBUTE_END       \*\)

/* Comments */
COMMENT_LINE        "//".*\n

COMMENT_BEGIN       "/*"
COMMENT_END         "*/"

%x in_comment

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
{ATTRIBUTE_START}      {return ATTRIBUTE_START       ;}
{ATTRIBUTE_END}        {return ATTRIBUTE_END         ;}


{CD_DEFINE}              {BEGIN(in_define);return CD_DEFINE;}
<in_define>{SIMPLE_ID}   {BEGIN(in_define_t); return SIMPLE_ID;}
<in_define_t>{MACRO_TEXT} {BEGIN(INITIAL);return MACRO_TEXT ;}

{COMMENT_LINE}         {/*return COMMENT_LINE; IGNORE */}
{COMMENT_BEGIN}        {BEGIN(in_comment)                     ;}

<in_comment>.|\n       {/* IGNORE                            */}
<in_comment>{COMMENT_END} {BEGIN(INITIAL);                     }

{CD_CELLDEFINE}          {return CD_CELLDEFINE         ;}
{CD_DEFAULT_NETTYPE}     {return CD_DEFAULT_NETTYPE    ;}
{CD_ELSE}                {return CD_ELSE               ;}
{CD_ELSIF}               {return CD_ELSIF              ;}
{CD_ENDCELLDEFINE}       {return CD_ENDCELLDEFINE      ;}
{CD_ENDIF}               {return CD_ENDIF              ;}
{CD_IFDEF}               {return CD_IFDEF              ;}
{CD_IFNDEF}              {return CD_IFNDEF             ;}
{CD_INCLUDE}             {return CD_INCLUDE            ;}
{CD_LINE}                {return CD_LINE               ;}
{CD_NOUNCONNECTED_DRIVE} {return CD_NOUNCONNECTED_DRIVE;}
{CD_RESETALL}            {return CD_RESETALL           ;}
{CD_TIMESCALE}           {return CD_TIMESCALE          ;}
{CD_UNCONNECTED_DRIVE}   {return CD_UNCONNECTED_DRIVE  ;}
{CD_UNDEF}               {return CD_UNDEF              ;}

{AT}                   {return AT                    ;}
{COMMA}                {return COMMA                 ;}
{HASH}                 {return HASH                  ;}
{DOT}                  {return DOT                   ;}
{EQ}                   {return EQ                    ;}
{COLON}                {return COLON                 ;}
{IDX_PRT_SEL}          {return IDX_PRT_SEL           ;}
{SEMICOLON}            {return SEMICOLON             ;}
{OPEN_BRACKET}         {return OPEN_BRACKET          ;}
{CLOSE_BRACKET}        {return CLOSE_BRACKET         ;}
{OPEN_SQ_BRACKET}      {return OPEN_SQ_BRACKET       ;}
{CLOSE_SQ_BRACKET}     {return CLOSE_SQ_BRACKET      ;}
{OPEN_SQ_BRACE}        {return OPEN_SQ_BRACE         ;}
{CLOSE_SQ_BRACE}       {return CLOSE_SQ_BRACE        ;}
{STAR}                 {return STAR                  ;}
{PLUS}                 {return PLUS                ;}
{MINUS}                {return MINUS               ;}
{ASL}                  {return ASL                 ;}
{ASR}                  {return ASR                 ;}
{LSL}                  {return LSL                 ;}
{LSR}                  {return LSR                 ;}
{DIV}                  {return DIV                 ;}
{POW}                  {return POW                 ;}
{MOD}                  {return MOD                 ;}
{GTE}                  {return GTE                 ;}
{LTE}                  {return LTE                 ;}
{GT}                   {return GT                  ;}
{LT}                   {return LT                  ;}
{L_NEG}                {return L_NEG               ;}
{L_AND}                {return L_AND               ;}
{L_OR}                 {return L_OR                ;}
{C_EQ}                 {return C_EQ                ;}
{L_EQ}                 {return L_EQ                ;}
{C_NEQ}                {return C_NEQ               ;}
{L_NEQ}                {return L_NEQ               ;}
{B_NEG}                {return B_NEG               ;}
{B_AND}                {return B_AND               ;}
{B_OR}                 {return B_OR                ;}
{B_XOR}                {return B_XOR               ;}
{B_EQU}                {return B_EQU               ;}
{B_NAND}               {return B_NAND              ;}
{B_NOR}                {return B_NOR               ;}
{TERNARY}              {return TERNARY             ;}

{NUMBER}               {return NUMBER;}
{UNSIGNED_NUM}         {return UNSIGNED_NUMBER;}

{ALWAYS}               {return KW_ALWAYS             ;} 
{AND}                  {return KW_AND                ;} 
{ASSIGN}               {return KW_ASSIGN             ;} 
{AUTOMATIC}            {return KW_AUTOMATIC          ;} 
{BEGIN}                {return KW_BEGIN              ;} 
{BUF}                  {return KW_BUF                ;} 
{BUFIF0}               {return KW_BUFIF0             ;} 
{BUFIF1}               {return KW_BUFIF1             ;} 
{CASE}                 {return KW_CASE               ;} 
{CASEX}                {return KW_CASEX              ;} 
{CASEZ}                {return KW_CASEZ              ;} 
{CELL}                 {return KW_CELL               ;} 
{CMOS}                 {return KW_CMOS               ;} 
{CONFIG}               {return KW_CONFIG             ;} 
{DEASSIGN}             {return KW_DEASSIGN           ;} 
{DEFAULT}              {return KW_DEFAULT            ;} 
{DEFPARAM}             {return KW_DEFPARAM           ;} 
{DESIGN}               {return KW_DESIGN             ;} 
{DISABLE}              {return KW_DISABLE            ;} 
{EDGE}                 {return KW_EDGE               ;} 
{ELSE}                 {return KW_ELSE               ;} 
{END}                  {return KW_END                ;} 
{ENDCASE}              {return KW_ENDCASE            ;} 
{ENDCONFIG}            {return KW_ENDCONFIG          ;} 
{ENDFUNCTION}          {return KW_ENDFUNCTION        ;} 
{ENDGENERATE}          {return KW_ENDGENERATE        ;} 
{ENDMODULE}            {return KW_ENDMODULE          ;} 
{ENDPRIMITIVE}         {return KW_ENDPRIMITIVE       ;} 
{ENDSPECIFY}           {return KW_ENDSPECIFY         ;} 
{ENDTABLE}             {return KW_ENDTABLE           ;} 
{ENDTASK}              {return KW_ENDTASK            ;} 
{EVENT}                {return KW_EVENT              ;} 
{FOR}                  {return KW_FOR                ;} 
{FORCE}                {return KW_FORCE              ;} 
{FOREVER}              {return KW_FOREVER            ;} 
{FORK}                 {return KW_FORK               ;} 
{FUNCTION}             {return KW_FUNCTION           ;} 
{GENERATE}             {return KW_GENERATE           ;} 
{GENVAR}               {return KW_GENVAR             ;} 
{HIGHZ0}               {return KW_HIGHZ0             ;} 
{HIGHZ1}               {return KW_HIGHZ1             ;} 
{IF}                   {return KW_IF                 ;} 
{IFNONE}               {return KW_IFNONE             ;} 
{INCDIR}               {return KW_INCDIR             ;} 
{INCLUDE}              {return KW_INCLUDE            ;} 
{INITIAL}              {return KW_INITIAL            ;} 
{INOUT}                {return KW_INOUT              ;} 
{INPUT}                {return KW_INPUT              ;} 
{INSTANCE}             {return KW_INSTANCE           ;} 
{INTEGER}              {return KW_INTEGER            ;} 
{JOIN}                 {return KW_JOIN               ;} 
{LARGE}                {return KW_LARGE              ;} 
{LIBLIST}              {return KW_LIBLIST            ;} 
{LIBRARY}              {return KW_LIBRARY            ;} 
{LOCALPARAM}           {return KW_LOCALPARAM         ;} 
{MACROMODULE}          {return KW_MACROMODULE        ;} 
{MEDIUM}               {return KW_MEDIUM             ;} 
{MODULE}               {return KW_MODULE             ;} 
{NAND}                 {return KW_NAND               ;} 
{NEGEDGE}              {return KW_NEGEDGE            ;} 
{NMOS}                 {return KW_NMOS               ;} 
{NOR}                  {return KW_NOR                ;} 
{NOSHOWCANCELLED}      {return KW_NOSHOWCANCELLED    ;} 
{NOT}                  {return KW_NOT                ;} 
{NOTIF0}               {return KW_NOTIF0             ;} 
{NOTIF1}               {return KW_NOTIF1             ;} 
{OR}                   {return KW_OR                 ;} 
{OUTPUT}               {return KW_OUTPUT             ;} 
{PARAMETER}            {return KW_PARAMETER          ;} 
{PMOS}                 {return KW_PMOS               ;} 
{POSEDGE}              {return KW_POSEDGE            ;} 
{PRIMITIVE}            {return KW_PRIMITIVE          ;} 
{PULL0}                {return KW_PULL0              ;} 
{PULL1}                {return KW_PULL1              ;} 
{PULLDOWN}             {return KW_PULLDOWN           ;} 
{PULLUP}               {return KW_PULLUP             ;} 
{PULSESTYLE_ONEVENT}   {return KW_PULSESTYLE_ONEVENT ;} 
{PULSESTYLE_ONDETECT}  {return KW_PULSESTYLE_ONDETECT;} 
{RCMOS}                {return KW_RCMOS              ;} 
{REAL}                 {return KW_REAL               ;} 
{REALTIME}             {return KW_REALTIME           ;} 
{REG}                  {return KW_REG                ;} 
{RELEASE}              {return KW_RELEASE            ;} 
{REPEAT}               {return KW_REPEAT             ;} 
{RNMOS}                {return KW_RNMOS              ;} 
{RPMOS}                {return KW_RPMOS              ;} 
{RTRAN}                {return KW_RTRAN              ;} 
{RTRANIF0}             {return KW_RTRANIF0           ;} 
{RTRANIF1}             {return KW_RTRANIF1           ;} 
{SCALARED}             {return KW_SCALARED           ;} 
{SHOWCANCELLED}        {return KW_SHOWCANCELLED      ;} 
{SIGNED}               {return KW_SIGNED             ;} 
{SMALL}                {return KW_SMALL              ;} 
{SPECIFY}              {return KW_SPECIFY            ;} 
{SPECPARAM}            {return KW_SPECPARAM          ;} 
{STRONG0}              {return KW_STRONG0            ;} 
{STRONG1}              {return KW_STRONG1            ;} 
{SUPPLY0}              {return KW_SUPPLY0            ;} 
{SUPPLY1}              {return KW_SUPPLY1            ;} 
{TABLE}                {return KW_TABLE              ;} 
{TASK}                 {return KW_TASK               ;} 
{TIME}                 {return KW_TIME               ;} 
{TRAN}                 {return KW_TRAN               ;} 
{TRANIF0}              {return KW_TRANIF0            ;} 
{TRANIF1}              {return KW_TRANIF1            ;} 
{TRI}                  {return KW_TRI                ;} 
{TRI0}                 {return KW_TRI0               ;} 
{TRI1}                 {return KW_TRI1               ;} 
{TRIAND}               {return KW_TRIAND             ;} 
{TRIOR}                {return KW_TRIOR              ;} 
{TRIREG}               {return KW_TRIREG             ;} 
{UNSIGNED}             {return KW_UNSIGNED           ;} 
{USE}                  {return KW_USE                ;} 
{VECTORED}             {return KW_VECTORED           ;} 
{WAIT}                 {return KW_WAIT               ;} 
{WAND}                 {return KW_WAND               ;} 
{WEAK0}                {return KW_WEAK0              ;} 
{WEAK1}                {return KW_WEAK1              ;} 
{WHILE}                {return KW_WHILE              ;} 
{WIRE}                 {return KW_WIRE               ;} 
{WOR}                  {return KW_WOR                ;} 
{XNOR}                 {return KW_XNOR               ;} 
{XOR}                  {return KW_XOR                ;} 

{SYSTEM_ID}            {return SYSTEM_ID             ;}
{SIMPLE_ID}            {yylval.identifier = yytext; return SIMPLE_ID ;}
{MACRO_IDENTIFIER}     {return MACRO_IDENTIFIER      ;}

{STRING}               {return STRING;                 }

<*>{NEWLINE}              {/*return NEWLINE; IGNORE */   }
<*>{SPACE}                {/*return SPACE;   IGNORE */   }
<*>{TAB}                  {/*return TAB;     IGNORE */   }

.                      {return ANY                   ;}

%%
