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

SIMPLE_IDENTIFIER           ([a-zA-Z_][a-zA-Z0-9_\$]*)
SYSTEM_IDENTIFIER           (\$[a-zA-Z0-9_\$][a-zA-Z0-9_\$]*)

HEX_DIGIT                   [0-9a-fA-F]
OCTAL_DIGIT                 [0-7]
DECIMAL_DIGIT               [0-9]

HEX_BASE                    [[sS][hH]]
OCTAL_BASE                  [[sS][oO]]
DECIMAL_BASE                [[sS][dD]]
BINARY_BASE                 [[sS][bB]]
EXP                         [eE]

OPEN_BRACKET                "("
CLOSE_BRACKET               ")"
OPEN_SQ_BRACKET             "["
CLOSE_SQ_BRACKET            "]"
STAR                        "*"

/* TODO Operators */

X_DIGIT                     [xX]
Z_DIGIT                     [zZ?]

NEWLINE             \n
TAB                 \t
SPACE               " "

%%

{EXP}                        {return token::EXP                       ;}
{OCTAL_DIGIT}                {return token::OCTAL_DIGIT               ;}
{DECIMAL_DIGIT}              {return token::DECIMAL_DIGIT             ;}
{HEX_DIGIT}                  {return token::HEX_DIGIT                 ;}

{HEX_BASE}                   {return token::HEX_BASE                  ;}
{OCTAL_BASE}                 {return token::OCTAL_BASE                ;}
{DECIMAL_BASE}               {return token::DECIMAL_BASE              ;}
{BINARY_BASE}                {return token::BINARY_BASE               ;}

{OPEN_BRACKET}               {return token::OPEN_BRACKET              ;}
{CLOSE_BRACKET}              {return token::CLOSE_BRACKET             ;}
{OPEN_SQ_BRACKET}            {return token::OPEN_SQ_BRACKET           ;}
{CLOSE_SQ_BRACKET}           {return token::CLOSE_SQ_BRACKET          ;}
{STAR}                       {return token::STAR                      ;}

{X_DIGIT}                    {return token::X_DIGIT                   ;}
{Z_DIGIT}                    {return token::Z_DIGIT                   ;}

{NEWLINE}                    {return token::WS                        ;}
{SPACE}                      {return token::WS                        ;}
{TAB}                        {return token::WS                        ;}


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

{SIMPLE_IDENTIFIER}    {return token::SIMPLE_IDENTIFIER         ;}
{SYSTEM_IDENTIFIER}    {return token::SYSTEM_FUNCTION_IDENTIFIER;}

%%
