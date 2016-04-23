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

%define parse.error verbose

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

%token COMMENT

%token CD_CELLDEFINE               
%token CD_DEFAULT_NETTYPE          
%token CD_DEFINE                   
%token CD_ELSE                     
%token CD_ELSIF                    
%token CD_ENDCELLDEFINE            
%token CD_ENDIF                    
%token CD_IFDEF                    
%token CD_IFNDEF                   
%token CD_INCLUDE                  
%token CD_LINE                     
%token CD_NOUNCONNECTED_DRIVE      
%token CD_RESETALL                 
%token CD_TIMESCALE                
%token CD_UNCONNECTED_DRIVE        
%token CD_UNDEF                    

%token KW_ALWAYS
%token KW_AND
%token KW_ASSIGN
%token KW_AUTOMATIC
%token KW_BEGIN
%token KW_BUF
%token KW_BUFIF0
%token KW_BUFIF1
%token KW_CASE
%token KW_CASEX
%token KW_CASEZ
%token KW_CELL
%token KW_CMOS
%token KW_CONFIG
%token KW_DEASSIGN
%token KW_DEFAULT
%token KW_DEFPARAM
%token KW_DESIGN
%token KW_DISABLE
%token KW_EDGE
%token KW_ELSE
%token KW_END
%token KW_ENDCASE
%token KW_ENDCONFIG
%token KW_ENDFUNCTION
%token KW_ENDGENERATE
%token KW_ENDMODULE
%token KW_ENDPRIMITIVE
%token KW_ENDSPECIFY
%token KW_ENDTABLE
%token KW_ENDTASK
%token KW_EVENT
%token KW_FOR
%token KW_FORCE
%token KW_FOREVER
%token KW_FORK
%token KW_FUNCTION
%token KW_GENERATE
%token KW_GENVAR
%token KW_HIGHZ0
%token KW_HIGHZ1
%token KW_IF
%token KW_IFNONE
%token KW_INCDIR
%token KW_INCLUDE
%token KW_INITIAL
%token KW_INOUT
%token KW_INPUT
%token KW_INSTANCE
%token KW_INTEGER
%token KW_JOIN
%token KW_LARGE
%token KW_LIBLIST
%token KW_LIBRARY
%token KW_LOCALPARAM
%token KW_MACROMODULE
%token KW_MEDIUM
%token KW_MODULE
%token KW_NAND
%token KW_NEGEDGE
%token KW_NMOS
%token KW_NOR
%token KW_NOSHOWCANCELLED
%token KW_NOT
%token KW_NOTIF0
%token KW_NOTIF1
%token KW_OR
%token KW_OUTPUT
%token KW_PARAMETER
%token KW_PMOS
%token KW_POSEDGE
%token KW_PRIMITIVE
%token KW_PULL0
%token KW_PULL1
%token KW_PULLDOWN
%token KW_PULLUP
%token KW_PULSESTYLE_ONEVENT
%token KW_PULSESTYLE_ONDETECT
%token KW_RCMOS
%token KW_REAL
%token KW_REALTIME
%token KW_REG
%token KW_RELEASE
%token KW_REPEAT
%token KW_RNMOS
%token KW_RPMOS
%token KW_RTRAN
%token KW_RTRANIF0
%token KW_RTRANIF1
%token KW_SCALARED
%token KW_SHOWCANCELLED
%token KW_SIGNED
%token KW_SMALL
%token KW_SPECIFY
%token KW_SPECPARAM
%token KW_STRONG0
%token KW_STRONG1
%token KW_SUPPLY0
%token KW_SUPPLY1
%token KW_TABLE
%token KW_TASK
%token KW_TIME
%token KW_TRAN
%token KW_TRANIF0
%token KW_TRANIF1
%token KW_TRI
%token KW_TRI0
%token KW_TRI1
%token KW_TRIAND
%token KW_TRIOR
%token KW_TRIREG
%token KW_UNSIGNED
%token KW_USE
%token KW_VECTORED
%token KW_WAIT
%token KW_WAND
%token KW_WEAK0
%token KW_WEAK1
%token KW_WHILE
%token KW_WIRE
%token KW_WOR
%token KW_XNOR
%token KW_XOR
%token SIMPLE_IDENTIFIER         
%token SYSTEM_FUNCTION_IDENTIFIER
%token SYSTEM_TASK_IDENTIFIER    
%token HEX_DIGIT                 
%token OCTAL_DIGIT               
%token DECIMAL_DIGIT             
%token HEX_BASE                  
%token OCTAL_BASE                
%token DECIMAL_BASE              
%token BINARY_BASE               
%token EXP                       
%token OPEN_BRACKET              
%token CLOSE_BRACKET             
%token OPEN_SQ_BRACKET           
%token CLOSE_SQ_BRACKET          
%token STAR                      
%token X_DIGIT
%token Z_DIGIT

%token END    0     "end of file"
%token UNKNOWN
%token IDENTIFIER
%token VALUE
%token WS
%token ANY

%token DEFINE
%token END_DEFINE

%token COMMENT_LINE
%token COMMENT_BLOCK


%%

/* Anex A.1.1 Library source text */

lib_text         : lib_texts

lib_texts        : 
                 | lib_descriptions
                 | lib_texts lib_descriptions
                 ;

lib_descriptions : lib_declaration
                 | include_statement
                 | cfg_declaration
                 ;

lib_declaration  : KW_LIBRARY lib_identifier file_path_specs inc_dirs ';'

inc_dirs         : 
                 | KW_INCDIR file_path_specs
                 ;

file_path_specs  : file_path_spec
                 | file_path_specs file_path_spec

file_path_spec   : file_path

include_statement: KW_INCLUDE file_path_spec ';'
                 ;

/* Anex A.1.2 Configuration source text */

cfg_declaration  : KW_CONFIG config_identifier ';' design_statement
                   cfg_rule_statements KW_ENDCONFIG
                 ;

design_statement : KW_DESIGN lib_cell_identifiers ';'

lib_cell_identifiers : lib_cell_identifiers lib_identifier '.' cell_identifier
                     | lib_cell_identifiers cell_identifier
                     |
                     ;

cfg_rule_statements  : default_clause liblist_clause
                     | inst_clause liblist_clause
                     | inst_clause use_clause
                     | cell_clause liblist_clause
                     | cell_clause use_clause
                     ;

default_clause  : KW_DEFAULT
                ;

inst_clause     : KW_INSTANCE inst_name
                ;

inst_name       : topmodule_identifier '.' instance_identifier
                | inst_name '.' instance_identifier
                | topmodule_identifier
                ;

cell_clause     : KW_CELL cell_identifier
                | KW_CELL lib_identifier '.' cell_identifier
                ;

liblist_clause  : KW_LIBLIST liblist_clauses
                ;

liblist_clauses : lib_identifier
                | liblist_clauses lib_identifier
                | 
                ;

use_clause      : KW_USE cell_identifier
                | KW_USE lib_identifier '.' cell_identifier
                | KW_USE cell_identifier ':' KW_CONFIG
                | KW_USE lib_identifier '.' cell_identifier ':' KW_CONFIG
                ;

/* A.1.3 Module and primitive source text */

source_text     : descriptions

descriptions    : descriptions description
                | description
                |
                ;

description     : module_declaration
                | udp_declaration
                ;

module_declaration : attribute_instances module_kw module_identifier
                     module_parameter_port_list list_of_ports ';' module_item
                     KW_ENDMODULE
                   | attribute_instances module_kw module_identifier
                     module_parameter_port_list list_of_port_declarations ';' 
                     non_port_module_item KW_ENDMODULE
                   ;

module_kw       : KW_MACROMODULE
                | KW_MODULE
                ;

/* A.1.4 Module parameters and ports */

module_param_list : '#' '(' module_params ')'
                  ;

module_params     : param_declaration
                  | module_params ',' param_declaration
                  ;

list_of_ports   :
                | '(' ports ')'
                ;

list_of_port_declarations   : '(' ')'
                            | '(' port_declarations ')'
                            ;

port_declarations           : port_declaration
                            | port_declarations ',' port_declaration
                            ;

ports           : ports ',' port
                | port
                ;

port            : port_expression
                | '.' port_identifier '(' port_expression ')'
                ;

port_expression : port_reference
                | port_expression ',' port_reference
                ;

port_reference  : port_identifier
                | port_identifier '[' constant_expression ']'
                | port_identifier '[' range_expression ']'
                ;

port_declaration : attribute_instances inout_declaration
                 | attribute_instances input_declaration
                 | attribute_instances output_declaration
                 ;

attribute_instances : attribute_instances attribute_instance
                    | attribute_instance
                    ;

/* A.1.5 Module Items */

module_item     : module_or_generate_item
                | port_declaration ';'
                | attribute_instances generated_instantiation
                | attribute_instances local_parameter_declaration
                | attribute_instances parameter_declaration
                | attribute_instances specify_block
                | attribute_instances specparam_declaration
                ;

module_or_generate_item : attribute_instances module_or_generate_item_declaration
                        | attribute_instances parameter_override
                        | attribute_instances continuous_assign
                        | attribute_instances gate_instantiation
                        | attribute_instances udp_instantiation
                        | attribute_instances module_instantiation
                        | attribute_instances initial_construct
                        | attribute_instances always_construct
                        ; 

module_or_generate_item_declaration : net_declaration
                                    | reg_declaration
                                    | integer_declaration
                                    | real_declaration
                                    | time_declaration
                                    | realtime_declaration
                                    | event_declaration
                                    | genvar_declaration
                                    | task_declaration
                                    | function_declaration
                                    ;

non_port_module_item : attribute_instances generated_instantiation
                     | attribute_instances local_parameter_declaration
                     | attribute_instances module_or_generate_item
                     | attribute_instances parameter_declaration
                     | attribute_instances specify_block
                     | attribute_instances specparam_declaration
                     ;

parameter_override   : KW_DEFPARAM list_of_param_assignments ';'
                     ;

/* A.2.1.1 Declaration types -> Module Parameter Declarations

local_parameter_declaration : KW_LOCALPARAM signed_o range_o list_of_param_assignments ';'
                            | KW_LOCALPARAM KW_INTEGER list_of_param_assignments ';'
                            | KW_LOCALPARAM KW_REAL list_of_param_assignments ';'
                            | KW_LOCALPARAM KW_REALTIME list_of_param_assignments ';'
                            | KW_LOCALPARAM KW_TIME list_of_param_assignments ';'

parameter_declaration : KW_PARAMETER signed_o range_o list_of_param_assignments ';'
                      | KW_PARAMETER KW_INTEGER list_of_param_assignments ';'
                      | KW_PARAMETER KW_REAL list_of_param_assignments ';'
                      | KW_PARAMETER KW_REALTIME list_of_param_assignments ';'
                      | KW_PARAMETER KW_TIME list_of_param_assignments ';'

specparam_declaration : KW_SPECPARAM range_o list_of_specparam_assignments ';'

range_o             : range
                    |
                    ;

signed_o            : KW_SIGNED
                    |
                    ;

/* A.2.1.2 Declaration Types -> Port Declarations */

inout_declaration : KW_INOUT net_type_o signed_o range_o 
                    list_of_port_identifiers
                  ;

input_declaration : KW_INPUT net_type_o signed_o range_o 
                    list_of_port_identifiers
                  ;

output_declaration: KW_OUTPUT net_type_o signed_o range_o 
                    list_of_port_identifiers
                  | KW_OUTPUT reg_o signed_o range_o list_of_port_identifiers
                  | KW_OUTPUT KW_REG signed_o range_o 
                    list_of_variable_port_identifiers
                  | KW_OUTPUT output_variable_type_o list_of_port_identifiers
                  | KW_OUTPUT output_variable_type 
                    list_of_variable_port_identifiers
                  ;

signed_o            : KW_SIGNED | ;
reg_o               : KW_REG | ;
range_o             : range | ;
net_type_o          : net_type | ;

/* A.2.1.3 Type Declarations */

event_declaration   : KW_EVENT list_of_event_identifiers';' ;
genvar_declaration  : KW_EVENT list_of_genvar_identifiers';' ;
integer_declaration : KW_EVENT list_of_variable_identifiers ';' ;

vect_or_scaled_o    : KW_VECTORED
                    | KW_SCALARED
                    |
                    ;

delay3_o            : delay3 | ;
drive_strength_o    : drive_strength | ;
charge_strength_o   : charge_strength | ;

net_declaration : net_type signed_o delay3_o list_of_net_identifiers ';'
                | net_type drive_strength_o signed_o delay3_o 
                  list_of_net_decl_assignments ';'
                | net_type vect_or_scaled_o signed_o range delay3_o 
                  list_of_net_identifiers ';'
                | net_type drive_strength_o vect_or_scaled_o signed_o range
                  delay3_o list_of_net_decl_assignments ';'
                | KW_TRIREG charge_strength_o signed_o delay3_o
                  list_of_net_identifiers ';'
                | KW_TRIREG drive_strength_o signed_o delay3_o
                  list_of_net_decl_assignments ';'
                | KW_TRIREG charge_strength_o vect_or_scaled_o signed_o
                  range delay3_o list_of_net_identifiers ';'
                | KW_TRIREG drive_strength_o vect_or_scaled_o signed_o
                  range delay3_o list_of_net_decl_assignments
                ;

real_declaration     : KW_REAL list_of_real_identifiers ';' ;
realtime_declaration : KW_REALTIME list_of_real_identifiers ';' ;
reg_declaration      : KW_REG signed_o range_o list_of_variable_identifiers ';'
                     ;

time_declaration     : KW_TIME list_of_variable_identifiers ';' ;

/* 2.2.1 Net and variable types */

/* 2.2.1 Strengths */

/* 2.2.1 Delays */

/* A.9.3 Identifiers */

cell_identifier         : identifier
config_identifier       : identifier
lib_identifier          : identifier
module_identifier       : identifier
port_identifier         : identifier
topmodule_identifier    : identifier
instance_identifier     : identifier

identifier              : simple_identifier
                        | escaped_identifier
                        ;

simple_identifier       : SIMPLE_IDENTIFIER
                        ;

escaped_identifier      : '\\' ANY WS

%%


void VL::VerilogParser::error( const std::string &err_message )
{
    std::cerr << "Line " << this->scanner.lineno() << ": ";
    std::cerr << "Parser Error: " << err_message << "\n"; 
    std::cerr << "\t" << this -> scanner.YYText()<<"\n";
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
