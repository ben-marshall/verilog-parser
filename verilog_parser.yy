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

attribute_instances_o : attribute_instances
                      |
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

real_declaration    : KW_REAL list_of_real_identifiers ';' ;
realtime_declaration: KW_REALTIME list_of_real_identifiers ';' ;
reg_declaration     : KW_REG signed_o range_o list_of_variable_identifiers ';'
                    ;

time_declaration    : KW_TIME list_of_variable_identifiers ';' ;

/* 2.2.1 Net and variable types */

net_type            : KW_SUPPLY0 | KW_SUPPLY1 | KW_TRI  | KW_TRIAND | 
                      KW_TRIOR   | KW_WIRE    | KW_WAND | KW_WOR
                    ;

output_variable_type: KW_INTEGER
                    | KW_TIME
                    ;

real_type           : real_identifier 
                    | real_identifier '=' constant_expression
                    | real_identifier_dimension dimensions
                    ;

dimensions          : dimension
                    | dimensions dimension
                    |
                    ;

variable_type       : variable_identifier 
                    | variable_identifier '=' constant_expression
                    | variable_identifier_dimension dimensions
                    ;

/* A.2.2.2 Strengths */

drive_strength      : '(' strength0 ',' strength1 ')'
                    | '(' strength1 ',' strength0 ')'
                    | '(' strength0 ',' KW_HIGHZ1 ')'
                    | '(' strength1 ',' KW_HIGHZ0 ')'
                    | '(' KW_HIGHZ0 ',' strength1 ')'
                    | '(' KW_HIGHZ1 ',' strength0 ')'
                    ;

strength0           : KW_SUPPLY0 | KW_STRONG0 | KW_PULL0 | KW_WEAK0 ;
strength1           : KW_SUPPLY1 | KW_STRONG1 | KW_PULL1 | KW_WEAK1 ;

charge_strength     : '(' KW_SMALL ')'
                    | '(' KW_MEDIUM ')'
                    | '(' KW_LARGE ')'
                    ;

/* A.2.2.3 Delays */

delay3              : '#' delay_value
                    | '#' '(' delay_value ')'
                    | '#' '(' delay_value ',' delay_value ')'
                    | '#' '(' delay_value ',' delay_value ',' delay_value ')'

delay2              : '#' delay_value
                    | '#' '(' delay_value ')'
                    | '#' '(' delay_value ',' delay_value ')'

delay_value         : unsigned_number
                    | parameter_identifier
                    | specparam_identifier
                    | mintypmax_expression
                    ;

/* A.2.3 Declaration Lists */

dimensions_o        : dimensions
                    |
                    ;

list_of_event_identifiers : event_identifier dimensions_o
                          | list_of_event_identifiers ',' event_identifier 
                            dimensions_o
                          ;

list_of_genvar_identifiers: genvar_identifier
                          : list_of_genvar_identifiers ',' genvar_identifier
                          ;

list_of_net_decl_assignments : net_decl_assignment
                             | list_of_net_decl_assignments ',' 
                               net_decl_assignment
                             ;

list_of_net_identifiers      : net_identifier dimensions_o
                             | list_of_net_identifiers ',' net_identifier
                               dimensions_o
                             ;

list_of_param_assignments    : param_assignment
                             | list_of_param_assignments ',' param_assignment
                             ;

list_of_port_identifiers     : port_identifier
                             | list_of_port_identifiers ',' port_identifier
                             ;

list_of_real_identifiers     : real_type
                             | list_of_real_identifiers ',' real_type
                             ;

list_of_specparam_assignments: specparam_assignment
                             | list_of_specparam_assignments ',' 
                               specparam_assignment
                             ;

list_of_variable_identifiers : variable_type
                             | list_of_variable_identifiers ',' variable_type
                             ;

eq_const_exp_o               : '=' constant_expression
                             |
                             ;

list_of_variable_port_identifiers : port_identifier eq_const_exp_o
                                  | list_of_variable_port_identifiers ',' 
                                    port_identifier eq_const_exp_o
                                  ;

/* A.2.4 Declaration Assignments */

net_decl_assignment     : net_identifier '=' expression ;

param_assignment        : parameter_identifier '=' constant_expression ;

specparam_assignment    : specparam_identifier '=' 
                          constant_mintypmax_expression
                        | pulse_control_specparam
                        ;

error_limit_value_o     : ',' error_limit_value
                        |
                        ;

pulse_control_specparam : KW_PATHPULSE '=' '(' reject_limit_value 
                          error_limit_value_o ')' ';'
                        | KW_PATHPULSE specify_input_terminal_descriptor '$'
                          specify_output_terminal_descriptor '=' '(' 
                          reject_limit_value error_limit_value_o ')' ';'
                        ;

error_limit_value       : limit_value ;
reject_limit_value      : limit_value ;
limit_value             : constant_mintypmax_expression ;

/* A.2.5 Declaration ranges */

dimension               : '[' dimension_constant_expression ':' 
                           dimension_constant_expression ']' ;

range                   : '[' msb_constant_expression ':' 
                           lsb_constant_expression ']' ;

/* A.2.6 Function Declarations */

automatic_o         : KW_AUTOMATIC | ;

function_declaration : KW_FUNCTION automatic_o signed_o range_or_type
                       function_identifer ';' function_item_declarations
                       function_statement KW_ENDFUNCTION
                     | KW_FUNCTION automatic_o signed_o range_or_type
                       function_identifer '(' function_port_list ')' ';' 
                       block_item_declarations
                       function_statement KW_ENDFUNCTION
                     ;

block_item_declarations    : block_item_declaration
                           | block_item_declarations 
                             block_item_declaration
                           |
                           ;

function_item_declarations : function_item_declaration
                           | function_item_declarations 
                             function_item_declaration
                           |
                           ;

function_item_declaration  : block_item_declaration 
                           | tf_input_declaration ';'
                           ;

function_port_list         : attribute_instances_o tf_input_declaration
                             tf_input_declarations;

tf_input_declarations      : 
                           | ',' attribute_instances_o tf_input_declaration
                             tf_input_declarations
                           ;

range_or_type              : range
                           | KW_INTEGER
                           | KW_REAL
                           | KW_REALTIME
                           | KW_TIME
                           ;

/* A.2.7 Task Declarations */

task_declaration    : KW_TASK automatic_o task_identifier ';'
                      task_item_declarations
                      statement
                      KW_ENDTASK
                    | KW_TASK automatic_o task_identifier 
                      '(' task_port_list ')' ';'
                      block_item_declarations
                      statement
                      KW_ENDTASK
                    ;

task_item_declaration : block_item_declaration
                      | attribute_instances tf_input_declaration ';'
                      | attribute_instances tf_output_declaration ';'
                      | attribute_instances tf_inout_declaration ';'
                      ;

task_port_list  : task_port_item
                | task_port_list ',' task_port_item
                ;

task_port_item  : attribute_instances tf_input_declaration ';'
                | attribute_instances tf_output_declaration ';'
                | attribute_instances tf_inout_declaration ';'

tf_input_declaration : KW_INPUT reg_o signed_o range_o list_of_port_identifiers
                     | KW_INPUT task_port_type_o list_of_port_identifiers
                     ;

task_port_type_o : task_port_type | ;
task_port_type   : KW_TIME
                 | KW_REAL
                 | KW_REALTIME
                 | KW_INTEGER
                 ;


/* A.2.8 Block item declarations */

block_item_declaration : attribute_instances block_reg_declaration
                       | attribute_instances event_declaration
                       | attribute_instances integer_declaration
                       | attribute_instances local_parameter_declaration
                       | attribute_instances parameter_declaration
                       | attribute_instances real_declaration
                       | attribute_instances realtime_declaration
                       | attribute_instances time_declaration
                       ;

block_reg_declaration : KW_REG signed_o range_o 
                        list_of_block_variable_identifiers ';'
                      ;

list_of_block_variable_identifiers : block_variable_type
                                   | list_of_block_variable_identifiers ',' 
                                     block_variable_type
                                   ;

block_variable_type : variable_identifier
                    | variable_identifier dimensions
                    ;

/* A.3.1 primitive instantiation and instances */

delay2_o : delay2 | ;

gate_instantiation : cmos_switchtype delay3_o cmos_switch_instances ';'
                   | enable_gatetype drive_strength_o delay3_o
                     enable_gate_instances ';'
                   | mos_switchtype delay3_o mos_switch_instances ';'
                   | n_input_gatetype drive_strength_o delay2_o
                     n_input_gate_instances ';'
                   | n_output_gatetype drive_strength_o delay2_o
                     n_output_gate_instances ';'
                   | pass_en_switchtype delay2_o 
                     pass_enable_switch_instances ';'
                   | pass_switchtype delay2_o 
                     pass_switch_instances ';'
                   | KW_PULLDOWN pulldown_strength_o pull_gate_instances ';'
                   | KW_PULLUP pullup_strength_o pull_gate_instances ';'
                   ;

pass_enable_switch_instances : pass_enable_switch_instance
                             | pass_enable_switch_instances ',' 
                               pass_enable_switch_instance
                             ;

pull_gate_instances : pull_gate_instance
                    | pull_gate_instances ',' 
                      pull_gate_instance
                    ;

pass_switch_instances :pass_switch_instance
                      | pass_switch_instances ',' 
                        pass_switch_instance
                      ;

n_output_gate_instances : n_output_gate_instance
                        | n_output_gate_instances ',' n_output_gate_instance
                        ;

n_input_gate_instances : n_input_gate_instance
                       | n_input_gate_instances ',' n_input_gate_instance
                       ;

mos_switch_instances : mos_switch_instance
                     | mos_switch_instances ',' mos_switch_instance
                     ;

cmos_switch_instances : cmos_switch_instance
                      | cmos_switch_instances ',' cmos_switch_instance
                      ;

enable_gate_instances : enable_gate_instance
                      | enable_gate_instances ',' enable_gate_instance 
                      ;

pass_enable_switch_instances : name_of_gate_instance '(' inout_terminal ','
                               inout_terminal ',' enable_terminal ')'
                             ;

pull_gate_instances          : name_of_gate_instance '(' output_terminal ')'
                             ;

pass_switch_instances        : name_of_gate_instance '(' inout_terminal ','
                               inout_terminal ')'
                             ;

n_output_gate_instances      : name_of_gate_instance '(' output_terminals ','
                               input_terminal ')'
                             ;

n_input_gate_instances       : name_of_gate_instance '(' output_terminal ','
                               input_terminals ')'
                             ;

mos_switch_instances         : name_of_gate_instance '(' output_terminal ','
                               input_terminal ',' enable_terminal ')'       
                             ;

cmos_switch_instances        : name_of_gate_instance '(' output_terminal ','
                               input_terminal ',' ncontrol_terminal ','
                               pcontrol_terminal ')'
                             ;

enable_gate_instances        : name_of_gate_instance '(' output_terminal ','
                               input_terminal ',' enable_terminal ')'
                             ;

name_of_gate_instance        : gate_instance_identifier range_o;

output_terminals             : output_terminal
                             | output_terminals ',' output_terminal
                             ;

input_terminals              : input_terminal
                             | input_terminals ',' input_terminal
                             ;

/* A.3.2 primitive strengths */

pulldown_strength           : '(' strength0 ',' strength1 ')'
                            | '(' strength1 ',' strength0 ')'
                            | '(' strength1 ')'
                            ;

pullup_strength             : '(' strength0 ',' strength1 ')'
                            | '(' strength1 ',' strength0 ')'
                            | '(' strength1 ')'
                            ;

/* A.3.3 primitive terminals */

enable_terminal     : expression;
inout_terminal      : net_lvalue;
input_terminal      : expression;
ncontrol_terminal   : expression;
output_terminal     : net_lvalue;
pcontrol_terminal   : expression;

/* A.3.4 primitive gate and switch types */

cmos_switchtype     : KW_CMOS | KW_RCMOS;
enable_gatetype     : KW_BUFIF0 | KW_BUFIF1 | KW_NOTIF0 | KW_NOTIF1;
mos_switchtype      : KW_NMOS | KW_PMOS | KW_RNMOS | KW_RPMOS;
n_input_gatetype    : KW_AND | KW_NAND | KW_OR | KW_NOR | KW_XOR | KW_XNOR;
n_output_gatetype   : KW_BUF | KW_NOT;
pass_en_switchtype  : KW_TRANIF0 | KW_TRANIF1 | KW_RTRANIF1 | KW_RTRANIF0;
pass_switchtype     : KW_TRAN | KW_RTRAN;

/* A.4.1 module instantiation */

module_instantiation: module_identifier parameter_value_assignment_o
                      module_instances ';'
                    ;

parameter_value_assignment_o : parameter_value_assignment | ;

parameter_value_assignment : '#' '(' list_of_parameter_assignments ')'
                           ;

list_of_parameter_assignments : ordered_parameter_assignments
                              | named_parameter_assignments
                              ;

ordered_parameter_assignments : ordered_parameter_assignment
                              | ordered_parameter_assignments ','
                                ordered_parameter_assignment
                              ;
named_parameter_assignments   : named_parameter_assignment
                              | named_parameter_assignments ','
                                named_parameter_assignment
                              ;

module_instances : module_instances ',' module_instance
                 | module_instance
                 ;

ordered_parameter_assignment : expression;

named_parameter_assignment : '.' parameter_identifier '(' expression_o ')';

expression_o : expression | ;

module_instance : name_of_instance '(' list_of_port_connections_o ')';
list_of_port_connections_o : list_of_port_connections | ;

name_of_instance : module_instance_identifier range_o;

list_of_port_connections : ordered_port_connections
                         | named_port_connections
                         ;

ordered_port_connections : ordered_port_connection
                         | ordered_port_connections ','
                           ordered_port_connection
                         ;

named_port_connections   : named_port_connection
                         | named_port_connections ','
                           named_port_connection
                         ;

ordered_port_connection : attribute_instances expression_o;

named_port_connection : attribute_instances '.' port_identifier '(' 
                        expression_o ')'
                      ;

/* A.4.2 Generated instantiation */

generated_instantiation : KW_GENERATE generate_items KW_ENDGENERATE ;

generate_items : generate_item
               | generate_items generate_item
               |
               ;

generate_item_or_null: generate_item | ;

generate_item : generate_conditional_statement
              | generate_case_statement
              | generate_loop_statement
              | generate_block
              | module_or_generate_item
              ;

generate_conditional_statement : KW_IF '(' constant_expression ')'
                                 generate_item_or_null KW_ELSE
                                 generate_item_or_null
                               | KW_IF '(' constant_expression ')'
                                 generate_item_or_null
                               ;

generate_case_statement : KW_CASE '(' constant_expression ')'
                          genvar_case_items KW_ENDCASE
                        ;

genvar_case_items : genvar_case_item
                  | genvar_case_items genvar_case_item
                  |
                  ;

genvar_case_item : constant_expressions ':' generate_item_or_null
                 | KW_DEFAULT ':' generate_item_or_null
                 | KW_DEFAULT     generate_item_or_null
                 ;

constant_expressions : constant_expression
                     | constant_expressions ',' constant_expression
                     ;

generate_loop_statement : KW_FOR '(' genvar_assignment ';' constant_expression
                          ';' genvar_assignment ')' KW_BEGIN ';'
                          generate_block_identifier generate_items KW_END

genvar_assignment : genvar_identifier '=' constant_expression;

generate_block : KW_BEGIN generate_items KW_END
               | KW_BEGIN ':' generate_block_identifier generate_items KW_END
               ;

/* A.5.1 UDP Declaration */

udp_declaration : attribute_instances_o KW_PRIMITIVE udp_identifier
                  '(' udp_port_list ')' ';'
                  udp_port_declarations udp_body KW_ENDPRIMITIVE
                | attribute_instances_o KW_PRIMITIVE udp_identifier
                  '(' udp_declaration_port_list ')' ';'
                  udp_body KW_ENDPRIMITIVE
                ;

udp_port_declarations : udp_port_declaration
                      | udp_port_declarations udp_port_declaration
                      ;

/* A.5.2 UDP Ports */

udp_port_list : output_port_identifier ',' input_port_identifiers;

input_port_identifiers : input_port_identifier
                       | input_port_identifiers ',' input_port_identifier
                       ;

udp_declaration_port_list : udp_output_declaration ',' udp_input_declarations;

udp_input_declarations  : udp_input_declaration
                        | udp_input_declarations udp_input_declaration
                        ;

udp_port_declaration : udp_output_declaration ';'
                     | udp_input_declaration ';'
                     | udp_reg_declaration ';'
                     ;

udp_output_declaration : attribute_instances_o KW_OUTPUT port_identifier
                       | attribute_instances_o KW_OUTPUT KW_REG port_identifier
                       | attribute_instances_o KW_OUTPUT KW_REG port_identifier
                         '=' constant_expression
                       ;

udp_input_declaration : attribute_instances_o KW_INPUT list_of_port_identifiers
                      ;

udp_reg_declaration : attribute_instances_o KW_REG variable_identifier
                    ;

/* A.5.3 UDP body */

udp_body            : combinational_body 
                    | sequential_body
                    ;

combinational_body  : KW_TABLE combinational_entrys KW_ENDTABLE;

combinational_entrys : combinational_entry
                     | combinational_entrys combinational_entry
                     ;

combinational_entry : level_input_list ':' output_symbol ';' ;

sequential_body : udp_initial_statement KW_TABLE sequential_entrys KW_ENDTABLE
                | KW_TABLE sequential_entrys KW_ENDTABLE
                ;

sequential_entrys     : sequential_entry
                      | sequential_entrys sequential_entry
                      ;

udp_initial_statement : KW_INITIAL output_port_identifier '=' init_val ';';

init_val              : '1’b0' | '1’b1' | '1’bx' | '1’bX' | '1’B0' 
                      | '1’B1' | '1’Bx' | '1’BX' | '1'    | '0'
                      ;

sequential_entry      : seq_input_list ':' current_state ':' next_state ';';
seq_input_list        : level_input_list | edge_input_list;

level_input_list      : level_symbols;

level_symbols_o       : level_symbols | ;
level_symbols         : level_symbol
                      | level_symbols level_symbol
                      ;

edge_input_list       :  level_symbols_o edge_indicator level_symbol_o;

edge_indicator        : '(' level_symbol level_symbol ')' 
                      | edge_symbol
                      ;

current_state         : level_symbol;

next_state            : output_symbol | '-'
                      ;

output_symbol : '0' | '1' | 'x' | 'X';

level_symbol :'0'|'1'|'x'|'X'|'?'|'b'|'B';

edge_symbol :'r'|'R'|'f'|'F'|'p'|'P'|'n'|'N'|'*';

/* A.5.4 UDP instantiation */

udp_instantiation : udp_identifier drive_strength_o delay2_o udp_instances ';'
                  ;

udp_instances : udp_instance
              | udp_instances ',' udp_instance
              ;

udp_instance : name_of_udp_instance '(' output_terminal ',' input_terminals ')'
             | '(' output_terminal ',' input_terminals ')'
             ;
name_of_udp_instance : udp_instance_identifier range_o ';' ;

/* A.6.1 Continuous assignment statements */

continuous_assign : KW_ASSIGN drive_strength_o delay3_o 
                    list_of_net_assignments ';'
                  ;

list_of_net_assignments : net_assignment
                        | list_of_net_assignments ',' net_assignment
                        ;

net_assignment : net_lvalue '=' expression;

/* A.6.2 Procedural blocks and assignments */

initial_construct   : KW_INITIAL statement ;
always_construct    : KW_ALWAYS statement ;

blocking_assignment : variable_lvalue '=' delay_or_event_control_o expression;
blocking_assignment : variable_lvalue '<' '=' delay_or_event_control_o 
                      expression
                    ;

delay_or_event_control_o : delay_or_event_control | ;

procedural_continuous_assignments : KW_ASSIGN variable_assignment
                                  | KW_DEASSIGN variable_lvalue
                                  | KW_FORCE variable_assignment
                                  | KW_FORCE net_assignment
                                  | KW_RELEASE variable_lvalue
                                  | KW_RELEASE net_lvalue
                                  ;

function_blocking_assignment : variable_lvalue ';' expression
                             ;

function_statement_or_null : function_statement
                           | attribute_instances_o ';'
                           ;

/* A.6.3 Parallel and sequential blocks */

block_item_declarations_o   : block_item_declarations | ;
block_item_declarations     : block_item_declaration
                            | block_item_declarations block_item_declaration
                            ;

function_statements_o   : function_statements | ;
function_statements     : function_statement
                        | function_statements function_statement
                        ;

function_seq_block : KW_BEGIN function_statements_o KW_END
                   | KW_BEGIN ':' block_identifier block_item_declarations_o
                     function_statements_o KW_END
                   ;

variable_assignment : variable_lvalue ';' expression
                    ;

par_block : KW_FORK statements_o KW_JOIN
          | KW_FORK ':' block_identifier block_item_declarations_o statements_o
            KW_JOIN
          ;

seq_block : KW_BEGIN statements_o KW_END
          | KW_BEGIN ':' block_identifier block_item_declarations_o 
            statements_o KW_END
          ;

/* A.6.4 Statements */

statement : attribute_instances_o blocking_assignment ';'
          | attribute_instances_o case_statement
          | attribute_instances_o conditional_statement
          | attribute_instances_o disable_statement
          | attribute_instances_o event_trigger
          | attribute_instances_o loop_statement
          | attribute_instances_o nonblocking_assignment ';'
          | attribute_instances_o par_block
          | attribute_instances_o procedural_continuous_assignments ';'
          | attribute_instances_o procedural_timing_control_statement
          | attribute_instances_o seq_block
          | attribute_instances_o system_task_enable
          | attribute_instances_o task_enable
          | attribute_instances_o wait_statement
          ;

statement_or_null : statement
                  | attribute_instances_o ';'
                  ;
                  
function_statement : attribute_instances_o function_blocking_assignment ';'
                   | attribute_instances_o function_case_statement
                   | attribute_instances_o function_conditional_statement
                   | attribute_instances_o function_loop_statement
                   | attribute_instances_o function_seq_block
                   | attribute_instances_o disable_statement
                   | attribute_instances_o system_task_enable
                   ;

/* A.6.5 Timing control statements */

/* A.6.6 Conditional Statemnets */

/* A.6.7 Case Statements */

/* A.6.8 looping statements */

/* A.6.9 task enable statements */

/* A.7.1 specify block declaration */

/* A.7.2 specify path declarations */

/* A.7.3 specify block terminals */

/* A.7.4 specify path delays */

/* A.7.5.1 System timing check commands */

/* A.7.5.2 System timing check command arguments */

/* A.7.5.3 System timing check evet definitions */

/* A.8.1 Concatenations */

/* A.8.2 Function calls */

/* A.8.3 Expression */

/* A.8.4 Primaries */

/* A.8.5 Expression left-side values */

/* A.8.6 Operators */

/* A.8.7 Numbers */

/* A.8.8 Strings */

/* A.9.1 Attributes */

/* A.9.2 Comments */

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
