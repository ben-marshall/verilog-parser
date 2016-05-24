%require  "3.0"
%defines 
%define parse.trace
%verbose


%define parse.error verbose

%{
    #include "stdio.h"
    #include "verilog_ast.h"

    void yyerror(const char *msg){
    printf("ERROR: %s\n", msg);
    }
%}

%code requires{
    #include "verilog_ast.h"
}


/* token types */
%union {
   ast_node             * node;
   ast_node_attributes  * node_attributes;
   ast_identifier         identifier;
   ast_lvalue           * lvalue;
   ast_primary          * primary;
   char                   boolean;
   char                 * string;
   char                 * number;
   char                 * term;
   char                 * operator;
   char                 * keyword;
}

%token <string> ANY
%token END
%token NEWLINE
%token SPACE
%token TAB

%token AT
%token COMMA
%token HASH               
%token DOT                
%token EQ
%token COLON              
%token IDX_PRT_SEL
%token SEMICOLON          
%token OPEN_BRACKET       
%token CLOSE_BRACKET      
%token OPEN_SQ_BRACKET    
%token CLOSE_SQ_BRACKET   
%token OPEN_SQ_BRACE      
%token CLOSE_SQ_BRACE     

%token <number> NUMBER
%token <number> UNSIGNED_NUMBER

%token <identifier> SYSTEM_ID
%token <identifier> SIMPLE_ID
%token <identifier> DEFINE_ID

%token ATTRIBUTE_START
%token ATTRIBUTE_END

%token <string> COMMENT_LINE
%token <string> COMMENT_BLOCK

%token <string> STRING

/* Operators Precedence */

%token <operator> STAR
%token <operator> PLUS
%token <operator> MINUS
%token <operator> ASL     
%token <operator> ASR     
%token <operator> LSL     
%token <operator> LSR     
%token <operator> DIV     
%token <operator> POW     
%token <operator> MOD     
%token <operator> GTE     
%token <operator> LTE     
%token <operator> GT      
%token <operator> LT      
%token <operator> L_NEG   
%token <operator> L_AND   
%token <operator> L_OR    
%token <operator> C_EQ    
%token <operator> L_EQ    
%token <operator> C_NEQ   
%token <operator> L_NEQ   
%token <operator> B_NEG   
%token <operator> B_AND   
%token <operator> B_OR    
%token <operator> B_XOR   
%token <operator> B_EQU   
%token <operator> B_NAND  
%token <operator> B_NOR   
%token <operator> TERNARY 

%token UNARY_OP

/* Operator Precedence */


%right  TERNARY                 /* Lowest Precedence */
%left   L_OR
%left   L_AND
%left   B_OR B_NOR
%left   B_EQU B_XOR
%left   B_NAND B_AND
%left   L_EQ C_EQ L_NEQ C_NEQ
%left   GT LT GTE LTE
%left   LSL LSR ASR ASL
%left   PLUS MINUS
%left   STAR DIV MOD
%left   POW
%left   L_NEG B_NEG UNARY_OP    /* Highest Precedence. */


/* Compiler / Preprocessor tokens */

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

%token <string>     MACRO_TEXT
%token <identifier> MACRO_IDENTIFIER

%token <keyword> KW_ALWAYS
%token <keyword> KW_AND
%token <keyword> KW_ASSIGN
%token <keyword> KW_AUTOMATIC
%token <keyword> KW_BEGIN
%token <keyword> KW_BUF
%token <keyword> KW_BUFIF0
%token <keyword> KW_BUFIF1
%token <keyword> KW_CASE
%token <keyword> KW_CASEX
%token <keyword> KW_CASEZ
%token <keyword> KW_CELL
%token <keyword> KW_CMOS
%token <keyword> KW_CONFIG
%token <keyword> KW_DEASSIGN
%token <keyword> KW_DEFAULT
%token <keyword> KW_DEFPARAM
%token <keyword> KW_DESIGN
%token <keyword> KW_DISABLE
%token <keyword> KW_EDGE
%token <keyword> KW_ELSE
%token <keyword> KW_END
%token <keyword> KW_ENDCASE
%token <keyword> KW_ENDCONFIG
%token <keyword> KW_ENDFUNCTION
%token <keyword> KW_ENDGENERATE
%token <keyword> KW_ENDMODULE
%token <keyword> KW_ENDPRIMITIVE
%token <keyword> KW_ENDSPECIFY
%token <keyword> KW_ENDTABLE
%token <keyword> KW_ENDTASK
%token <keyword> KW_EVENT
%token <keyword> KW_FOR
%token <keyword> KW_FORCE
%token <keyword> KW_FOREVER
%token <keyword> KW_FORK
%token <keyword> KW_FUNCTION
%token <keyword> KW_GENERATE
%token <keyword> KW_GENVAR
%token <keyword> KW_HIGHZ0
%token <keyword> KW_HIGHZ1
%token <keyword> KW_IF
%token <keyword> KW_IFNONE
%token <keyword> KW_INCDIR
%token <keyword> KW_INCLUDE
%token <keyword> KW_INITIAL
%token <keyword> KW_INOUT
%token <keyword> KW_INPUT
%token <keyword> KW_INSTANCE
%token <keyword> KW_INTEGER
%token <keyword> KW_JOIN
%token <keyword> KW_LARGE
%token <keyword> KW_LIBLIST
%token <keyword> KW_LIBRARY
%token <keyword> KW_LOCALPARAM
%token <keyword> KW_MACROMODULE
%token <keyword> KW_MEDIUM
%token <keyword> KW_MODULE
%token <keyword> KW_NAND
%token <keyword> KW_NEGEDGE
%token <keyword> KW_NMOS
%token <keyword> KW_NOR
%token <keyword> KW_NOSHOWCANCELLED
%token <keyword> KW_NOT
%token <keyword> KW_NOTIF0
%token <keyword> KW_NOTIF1
%token <keyword> KW_OR
%token <keyword> KW_OUTPUT
%token <keyword> KW_PARAMETER
%token <keyword> KW_PATHPULSE
%token <keyword> KW_PMOS
%token <keyword> KW_POSEDGE
%token <keyword> KW_PRIMITIVE
%token <keyword> KW_PULL0
%token <keyword> KW_PULL1
%token <keyword> KW_PULLDOWN
%token <keyword> KW_PULLUP
%token <keyword> KW_PULSESTYLE_ONEVENT
%token <keyword> KW_PULSESTYLE_ONDETECT
%token <keyword> KW_RCMOS
%token <keyword> KW_REAL
%token <keyword> KW_REALTIME
%token <keyword> KW_REG
%token <keyword> KW_RELEASE
%token <keyword> KW_REPEAT
%token <keyword> KW_RNMOS
%token <keyword> KW_RPMOS
%token <keyword> KW_RTRAN
%token <keyword> KW_RTRANIF0
%token <keyword> KW_RTRANIF1
%token <keyword> KW_SCALARED
%token <keyword> KW_SHOWCANCELLED
%token <keyword> KW_SIGNED
%token <keyword> KW_SMALL
%token <keyword> KW_SPECIFY
%token <keyword> KW_SPECPARAM
%token <keyword> KW_STRONG0
%token <keyword> KW_STRONG1
%token <keyword> KW_SUPPLY0
%token <keyword> KW_SUPPLY1
%token <keyword> KW_TABLE
%token <keyword> KW_TASK
%token <keyword> KW_TIME
%token <keyword> KW_TRAN
%token <keyword> KW_TRANIF0
%token <keyword> KW_TRANIF1
%token <keyword> KW_TRI
%token <keyword> KW_TRI0
%token <keyword> KW_TRI1
%token <keyword> KW_TRIAND
%token <keyword> KW_TRIOR
%token <keyword> KW_TRIREG
%token <keyword> KW_UNSIGNED
%token <keyword> KW_USE
%token <keyword> KW_VECTORED
%token <keyword> KW_WAIT
%token <keyword> KW_WAND
%token <keyword> KW_WEAK0
%token <keyword> KW_WEAK1
%token <keyword> KW_WHILE
%token <keyword> KW_WIRE
%token <keyword> KW_WOR
%token <keyword> KW_XNOR
%token <keyword> KW_XOR

%start grammar_begin

%type <boolean> reg_o
%type <boolean> signed_o
%type <identifier> arrayed_identifier
%type <identifier> block_identifier
%type <identifier> cell_identifier
%type <identifier> config_identifier
%type <identifier> edge_identifier
%type <identifier> edge_identifier_o
%type <identifier> escaped_arrayed_identifier
%type <identifier> escaped_hierarchical_branch
%type <identifier> escaped_hierarchical_identifier
%type <identifier> escaped_hierarchical_identifiers
%type <identifier> escaped_identifier
%type <identifier> event_identifier
%type <identifier> function_identifier
%type <identifier> gate_instance_identifier
%type <identifier> generate_block_identifier
%type <identifier> genvar_identifier
%type <identifier> hierarchical_block_identifier
%type <identifier> hierarchical_event_identifier
%type <identifier> hierarchical_function_identifier
%type <identifier> hierarchical_identifier
%type <identifier> hierarchical_net_identifier
%type <identifier> hierarchical_task_identifier
%type <identifier> hierarchical_variable_identifier
%type <identifier> identifier
%type <identifier> identifier_csv
%type <identifier> inout_port_identifier
%type <identifier> input_identifier
%type <identifier> input_port_identifier
%type <identifier> input_port_identifiers
%type <identifier> instance_identifier
%type <identifier> instance_identifier_os
%type <identifier> lib_cell_identifier_os
%type <identifier> library_identifier
%type <identifier> library_identifier_os
%type <identifier> list_of_block_variable_identifiers
%type <identifier> list_of_event_identifiers
%type <identifier> list_of_genvar_identifiers
%type <identifier> list_of_net_identifiers
%type <identifier> list_of_param_assignments
%type <identifier> list_of_port_identifiers
%type <identifier> list_of_real_identifiers
%type <identifier> list_of_variable_identifiers
%type <identifier> list_of_variable_port_identifiers
%type <identifier> module_identifier
%type <identifier> module_instance_identifier
%type <identifier> net_identifier
%type <identifier> output_identifier
%type <identifier> output_port_identifier
%type <identifier> parameter_identifier
%type <identifier> port_identifier
%type <identifier> real_identifier
%type <identifier> simple_arrayed_identifier
%type <identifier> simple_hierarchical_branch
%type <identifier> simple_hierarchical_identifier
%type <identifier> simple_identifier
%type <identifier> specparam_identifier
%type <identifier> system_function_identifier
%type <identifier> system_task_identifier
%type <identifier> task_identifier
%type <identifier> text_macro_name
%type <identifier> text_macro_usage
%type <identifier> topmodule_identifier
%type <identifier> udp_identifier
%type <identifier> udp_instance_identifier
%type <identifier> variable_identifier
%type <node> actual_argument
%type <node> always_construct
%type <identifier> attr_name
%type <node_attributes> attr_spec
%type <node_attributes> attr_specs
%type <node> attribute_instances
%type <node> automatic_o
%type <node> block_item_declaration
%type <node> block_item_declarations
%type <node> block_reg_declaration
%type <node> block_variable_type
%type <node> blocking_assignment
%type <node> case_item
%type <node> case_items
%type <node> case_statement
%type <node> cell_clause
%type <node> charge_strength
%type <node> cmos_switch_instance
%type <node> cmos_switch_instances
%type <node> cmos_switchtype
%type <node> combinational_body
%type <node> combinational_entry
%type <node> combinational_entrys
%type <node> compiler_directive
%type <node> compiler_directives
%type <node> concatenation
%type <node> concatenation_cont
%type <node> conditional_compile_directive
%type <node> conditional_expression
%type <node> conditional_statement
%type <node> config_declaration
%type <node> config_rule_statement
%type <node> config_rule_statement_os
%type <node> constant_concatenation
%type <node> constant_concatenation_cont
%type <node> constant_expression
%type <node> constant_expression_o
%type <node> constant_expressions
%type <node> constant_function_call
%type <node> constant_function_call_pid
%type <node> constant_mintypmax_expression
%type <node> constant_multiple_concatenation
%type <primary> constant_primary
%type <node> constant_range_expression
%type <node> continuous_assign
%type <node> current_state
%type <node> data_source_expression
%type <node> default_clause
%type <node> default_net_type_cd
%type <node> delay2
%type <node> delay2_o
%type <node> delay3
%type <node> delay3_o
%type <node> delay_control
%type <node> delay_or_event_control
%type <node> delay_or_event_control_o
%type <node> delay_value
%type <node> description
%type <node> design_statement
%type <node> dimension
%type <node> dimensions
%type <node> dimensions_o
%type <node> disable_statement
%type <node> drive_strength
%type <node> drive_strength_o
%type <node> edge_indicator
%type <node> edge_input_list
%type <node> edge_sensitive_path_declaration
%type <node> edge_symbol
%type <node> else_if_statements
%type <node> enable_gate_instance
%type <node> enable_gate_instances
%type <node> enable_gatetype
%type <node> enable_terminal
%type <node> eq_const_exp_o
%type <node> error_limit_value
%type <node> error_limit_value_o
%type <node> event_control
%type <node> event_declaration
%type <node> event_expression
%type <node> event_trigger
%type <node> expression
%type <node> expression_o
%type <node> expressions
%type <node> expressions_o
%type <node> file_path_spec
%type <node> file_path_specs
%type <node> full_edge_sensitive_path_description
%type <node> full_path_description
%type <node> function_blocking_assignment
%type <node> function_call
%type <node> function_case_item
%type <node> function_case_items
%type <node> function_case_statement
%type <node> function_conditional_statement
%type <node> function_declaration
%type <node> function_else_if_statements
%type <node> function_if_else_if_statement
%type <node> function_item_declaration
%type <node> function_item_declarations
%type <node> function_loop_statement
%type <node> function_port_list
%type <node> function_seq_block
%type <node> function_statement
%type <node> function_statement_or_null
%type <node> function_statements
%type <node> function_statements_o
%type <node> gate_enable
%type <node> gate_instantiation
%type <node> gate_n_input
%type <node> gate_n_input_a_ds
%type <node> gate_n_input_a_id
%type <node> gate_n_output
%type <node> gate_n_output_a_ds
%type <node> gate_n_output_a_id
%type <node> gate_n_output_a_ot
%type <node> gate_pass_en_switch
%type <node> gatetype_n_input
%type <node> gatetype_n_output
%type <node> generate_block
%type <node> generate_case_statement
%type <node> generate_conditional_statement
%type <node> generate_item
%type <node> generate_item_or_null
%type <node> generate_items
%type <node> generate_loop_statement
%type <node> generated_instantiation
%type <node> genvar_assignment
%type <node> genvar_case_item
%type <node> genvar_case_items
%type <node> genvar_declaration
%type <node> grammar_begin
%type <node> if_else_if_statement
%type <node> ifdef_directive
%type <node> ifndef_directive
%type <node> include_directive
%type <node> include_statement
%type <node> init_val
%type <node> initial_construct
%type <node> inout_declaration
%type <node> inout_terminal
%type <node> input_declaration
%type <node> input_terminal
%type <node> input_terminals
%type <node> inst_clause
%type <node> inst_name
%type <node> integer_declaration
%type <node> level_input_list
%type <node> level_symbol
%type <node> level_symbols
%type <node> level_symbols_o
%type <node> liblist_clause
%type <node> library_declaration
%type <node> library_descriptions
%type <node> library_text
%type <node> limit_value
%type <node> line_directive
%type <node> list_of_actual_arguments
%type <node> list_of_attribute_instances
%type <node> list_of_formal_arguments
%type <node> list_of_net_assignments
%type <node> list_of_net_decl_assignments
%type <node> list_of_parameter_assignments
%type <node> list_of_path_delay_expressions
%type <node> list_of_path_inputs
%type <node> list_of_path_outputs
%type <node> list_of_port_connections
%type <node> list_of_port_declarations
%type <node> list_of_ports
%type <node> list_of_specparam_assignments
%type <node> local_parameter_declaration
%type <node> loop_statement
%type <node> mintypmax_expression
%type <node> modpath_concatenation_cont
%type <node> module_declaration
%type <node> module_instance
%type <node> module_instances
%type <node> module_instantiation
%type <node> module_item
%type <node> module_item_os
%type <node> module_or_generate_item
%type <node> module_or_generate_item_declaration
%type <node> module_parameter_port_list
%type <node> module_params
%type <node> module_path_concatenation
%type <node> module_path_conditional_expression
%type <node> module_path_expression
%type <node> module_path_mintypemax_expression
%type <node> module_path_multiple_concatenation
%type <primary> module_path_primary
%type <node> mos_switch_instance
%type <node> mos_switch_instances
%type <node> mos_switchtype
%type <node> multiple_concatenation
%type <node> n_input_gate_instance
%type <node> n_input_gate_instances
%type <node> n_output_gate_instance
%type <node> n_output_gate_instances
%type <node> name_of_gate_instance
%type <node> name_of_instance
%type <node> name_of_udp_instance
%type <node> named_parameter_assignment
%type <node> named_parameter_assignments
%type <node> named_port_connection
%type <node> named_port_connections
%type <node> ncontrol_terminal
%type <node> net_assignment
%type <node> net_concatenation
%type <node> net_concatenation_cont
%type <node> net_concatenation_value
%type <node> net_dec_p_delay
%type <node> net_dec_p_ds
%type <node> net_dec_p_range
%type <node> net_dec_p_si
%type <node> net_dec_p_vs
%type <node> net_decl_assignment
%type <node> net_declaration
%type <lvalue> net_lvalue
%type <node> net_type
%type <node> net_type_o
%type <node> next_state
%type <node> non_port_module_item
%type <node> non_port_module_item_os
%type <node> nonblocking_assignment
%type <node> ordered_parameter_assignment
%type <node> ordered_parameter_assignments
%type <node> ordered_port_connection
%type <node> ordered_port_connections
%type <node> output_declaration
%type <node> output_symbol
%type <node> output_terminal
%type <node> output_terminals
%type <node> output_variable_type
%type <node> output_variable_type_o
%type <node> par_block
%type <node> parallel_edge_sensitive_path_description
%type <node> parallel_path_description
%type <node> param_assignment
%type <node> parameter_declaration
%type <node> parameter_override
%type <node> parameter_value_assignment
%type <node> parameter_value_assignment_o
%type <node> pass_en_switchtype
%type <node> pass_enable_switch_instance
%type <node> pass_enable_switch_instances
%type <node> pass_switch_instance
%type <node> pass_switch_instances
%type <node> pass_switchtype
%type <node> path_declaration
%type <node> path_delay_expression
%type <node> path_delay_value
%type <node> pcontrol_terminal
%type <node> polarity_operator
%type <node> polarity_operator_o
%type <node> port
%type <node> port_declaration
%type <node> port_declaration_l
%type <node> port_declarations
%type <node> port_dir
%type <node> port_expression
%type <node> port_reference
%type <node> ports
%type <primary> primary
%type <node> procedural_continuous_assignments
%type <node> procedural_timing_control_statement
%type <node> pull_gate_instance
%type <node> pull_gate_instances
%type <node> pulldown_strength
%type <node> pulldown_strength_o
%type <node> pullup_strength
%type <node> pullup_strength_o
%type <node> pulse_control_specparam
%type <node> pulsestyle_declaration
%type <node> range
%type <node> range_expression
%type <node> range_expression_o
%type <node> range_o
%type <node> range_or_type
%type <node> real_declaration
%type <node> real_type
%type <node> realtime_declaration
%type <node> reg_dec_p_range
%type <node> reg_dec_p_signed
%type <node> reg_declaration
%type <node> reject_limit_value
%type <node> seq_block
%type <node> seq_input_list
%type <node> sequential_body
%type <node> sequential_entry
%type <node> sequential_entrys
%type <node> showcancelled_declaration
%type <node> simple_path_declaration
%type <node> source_text
%type <node> specify_block
%type <node> specify_input_terminal_descriptor
%type <node> specify_item
%type <node> specify_items
%type <node> specify_items_o
%type <node> specify_output_terminal_descriptor
%type <node> specparam_assignment
%type <node> specparam_declaration
%type <node> sq_bracket_constant_expressions
%type <node> sq_bracket_expressions
%type <node> state_dependent_path_declaration
%type <node> statement
%type <node> statement_or_null
%type <node> statements
%type <node> statements_o
%type <node> strength0
%type <node> strength1
%type <node> system_function_call
%type <node> system_task_enable
%type <node> system_timing_check
%type <node> task_declaration
%type <node> task_enable
%type <node> task_item_declaration
%type <node> task_item_declarations
%type <node> task_port_item
%type <node> task_port_list
%type <node> task_port_type
%type <node> task_port_type_o
%type <node> text_macro_definition
%type <node> tf_inout_declaration
%type <node> tf_input_declaration
%type <node> tf_input_declarations
%type <node> tf_output_declaration
%type <node> time
%type <node> time_declaration
%type <node> timescale_directive
%type <node> udp_body
%type <node> udp_declaration
%type <node> udp_declaration_port_list
%type <node> udp_initial_statement
%type <node> udp_input_declaration
%type <node> udp_input_declarations
%type <node> udp_instance
%type <node> udp_instances
%type <node> udp_instantiation
%type <node> udp_output_declaration
%type <node> udp_port_declaration
%type <node> udp_port_declarations
%type <node> udp_port_list
%type <node> udp_reg_declaration
%type <node> undefine_compiler_directive
%type <node> use_clause
%type <node> variable_assignment
%type <node> variable_concatenation
%type <node> variable_concatenation_cont
%type <node> variable_concatenation_value
%type <lvalue> variable_lvalue
%type <node> variable_type
%type <node> wait_statement
%type <number> number
%type <number> unsigned_number
%type <operator> binary_module_path_operator
%type <operator> unary_module_path_operator
%type <operator> unary_operator
%type <string> CB
%type <string> OB
%type <string> anys
%type <string> block_comment
%type <string> comment
%type <string> file_path
%type <string> macro_text
%type <string> one_line_comment
%type <string> string
%type <string> white_space

%%
/* Start variables */

grammar_begin : library_text 
              | config_declaration
              | source_text
              | white_space
              | comment
              ;

/* 19.0 Compiler Directives */

/* 
These are not properly handled at the moment and are completely
ignored by the parser.
*/

default_net_type_cd : CD_DEFAULT_NETTYPE net_type
                    ;

compiler_directives : compiler_directive
                    | compiler_directives compiler_directive
                    ;

compiler_directive  : CD_CELLDEFINE
                    | CD_ENDCELLDEFINE
                    | CD_RESETALL
                    | CD_UNCONNECTED_DRIVE
                    | CD_NOUNCONNECTED_DRIVE
                    | default_net_type_cd
                    | text_macro_definition
                    | undefine_compiler_directive
                    | conditional_compile_directive
                    | include_directive
                    | line_directive
                    | timescale_directive
                    ;

timescale_directive : CD_TIMESCALE time DIV time;

time: unsigned_number ANY
    | unsigned_number ANY ANY
    ;

line_directive  : CD_LINE number string unsigned_number

text_macro_definition : CD_DEFINE text_macro_name macro_text
                      ;

text_macro_name     : SIMPLE_ID 
                    | SIMPLE_ID list_of_formal_arguments
                    ;

list_of_formal_arguments : identifier_csv
                         ; 

macro_text : MACRO_TEXT;   

text_macro_usage : MACRO_IDENTIFIER list_of_actual_arguments
                 | MACRO_IDENTIFIER
                 ;

list_of_actual_arguments : actual_argument
                         | list_of_actual_arguments COMMA actual_argument
                         ;

actual_argument : expression
                ; 

undefine_compiler_directive : CD_UNDEF MACRO_IDENTIFIER
                            ;

conditional_compile_directive   : ifdef_directive
                                | ifndef_directive
                                | CD_ENDIF
                                ;

ifdef_directive : CD_IFDEF SIMPLE_ID;
ifndef_directive: CD_IFNDEF SIMPLE_ID;

include_directive   : CD_INCLUDE string;

/* A.1.1 Library Source Text */

library_text : library_descriptions
             | library_text library_descriptions

library_descriptions : library_declaration
                     | include_statement
                     | config_declaration
                     | compiler_directives
                     ;

library_declaration : KW_LIBRARY library_identifier 
                      file_path_specs
                      SEMICOLON
                    | KW_LIBRARY library_identifier 
                      file_path_specs
                      KW_INCDIR file_path_specs
                      SEMICOLON
                    ;

file_path_specs : file_path_spec
                | file_path_specs COMMA file_path_spec
                ;

file_path_spec : file_path
               ;

file_path : string;

include_statement : KW_INCLUDE file_path_spec SEMICOLON
                  ;
   
/* A.1.2 Configuration Source Text */

config_declaration : KW_CONFIG config_identifier SEMICOLON
                     design_statement
                     config_rule_statement_os
                     KW_ENDCONFIG
                   ;

design_statement : KW_DESIGN lib_cell_identifier_os SEMICOLON
                 ;

lib_cell_identifier_os :
                       | cell_identifier
                       | library_identifier DOT cell_identifier
                       | lib_cell_identifier_os cell_identifier
                       | lib_cell_identifier_os library_identifier DOT 
                         cell_identifier
                       ;

config_rule_statement_os :
                         | config_rule_statement
                         | config_rule_statement_os config_rule_statement
                         ;

config_rule_statement : default_clause liblist_clause
                      | inst_clause liblist_clause
                      | inst_clause use_clause
                      | cell_clause liblist_clause
                      | cell_clause use_clause
                      ;

default_clause  : KW_DEFAULT
                ;

inst_clause : KW_INSTANCE inst_name
            ;

inst_name   : topmodule_identifier instance_identifier_os
            ;

instance_identifier_os  :
                        | DOT instance_identifier
                        | instance_identifier_os DOT instance_identifier
                        ;

cell_clause : KW_CELL cell_identifier
            | KW_CELL library_identifier DOT cell_identifier
            ;

liblist_clause  : KW_LIBLIST library_identifier_os
                ;

library_identifier_os : 
                      | library_identifier
                      | library_identifier_os library_identifier
                      ;

use_clause : KW_USE library_identifier DOT cell_identifier COLON KW_CONFIG
           | KW_USE library_identifier DOT cell_identifier
           | KW_USE cell_identifier COLON KW_CONFIG
           | KW_USE cell_identifier
           ;

/* A.1.3 Module and primitive source text. */

source_text : description
            | source_text description
            ;

description : module_declaration
            | udp_declaration
            | compiler_directives
            ;

module_declaration : attribute_instances
                     module_keyword
                     module_identifier
                     module_parameter_port_list
                     list_of_port_declarations
                     SEMICOLON
                     non_port_module_item_os
                     KW_ENDMODULE
                   | attribute_instances
                     module_keyword
                     module_identifier
                     module_parameter_port_list
                     list_of_ports
                     SEMICOLON
                     module_item_os
                     KW_ENDMODULE
                   ;

module_keyword     : KW_MODULE
                   | KW_MACROMODULE
                   ;

/* A.1.4 Module parameters and ports */

module_parameter_port_list  : 
                            | HASH OPEN_BRACKET module_params CLOSE_BRACKET
                            ;

module_params     : 
                  | parameter_declaration
                  | module_params COMMA parameter_declaration
                  ;

list_of_ports   :
                | OPEN_BRACKET ports CLOSE_BRACKET 
                ;

list_of_port_declarations   : OPEN_BRACKET CLOSE_BRACKET
                            | OPEN_BRACKET port_declarations CLOSE_BRACKET
                            ;

port_declarations : port_declarations COMMA port_dir port_declaration_l
                  | port_declarations COMMA identifier_csv port_dir
                    port_declaration_l
                  | port_dir port_declaration_l
                  ;

identifier_csv    : 
                  | identifier
                  | COMMA identifier identifier_csv
                  ;

port_dir          : attribute_instances KW_OUTPUT
                  | attribute_instances KW_INPUT
                  | attribute_instances KW_INOUT
                  ;

port_declaration_l: net_type_o signed_o range_o port_identifier
                  | reg_o signed_o range_o port_identifier
                  | output_variable_type_o port_identifier
                  | output_variable_type port_identifier eq_const_exp_o
                  | KW_REG signed_o range_o port_identifier eq_const_exp_o
                  ;

port_declaration  : inout_declaration
                  | input_declaration
                  | output_declaration
                  ;

ports           : 
                | ports COMMA port
                | port 
                ;

port            : port_expression
                | DOT port_identifier OPEN_BRACKET port_expression
                  CLOSE_BRACKET
                ;

port_expression : port_reference 
                | port_expression COMMA port_reference
                ;

port_reference  : port_identifier
                | port_identifier OPEN_SQ_BRACKET constant_expression
                  CLOSE_SQ_BRACKET 
                | port_identifier OPEN_SQ_BRACKET
                  range_expression CLOSE_SQ_BRACKET
                ;

/* A.1.5 Module Items */

module_item_os : 
               | module_item
               | module_item_os module_item
               ;

non_port_module_item_os : 
                        | non_port_module_item
                        | non_port_module_item_os non_port_module_item
                        ;

module_item : module_or_generate_item
            | port_declaration SEMICOLON
            | attribute_instances generated_instantiation
            | attribute_instances local_parameter_declaration
            | attribute_instances parameter_declaration
            | attribute_instances specify_block
            | attribute_instances specparam_declaration
            ;

module_or_generate_item : attribute_instances 
                          module_or_generate_item_declaration
                        | attribute_instances parameter_override
                        | attribute_instances continuous_assign
                        | attribute_instances gate_instantiation
                        | attribute_instances udp_instantiation
                        | attribute_instances module_instantiation
                        | attribute_instances initial_construct
                        | attribute_instances always_construct
                        | compiler_directives
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

parameter_override  : KW_DEFPARAM list_of_param_assignments SEMICOLON
                    ;

/* A.2.1.1 Module Parameter Declarations */

signed_o : KW_SIGNED {$$=1;}|{$$=0;} ;
range_o  : range     | ;

local_parameter_declaration : KW_LOCALPARAM signed_o range_o
                              list_of_param_assignments SEMICOLON
                            | KW_LOCALPARAM KW_INTEGER 
                              list_of_param_assignments SEMICOLON
                            | KW_LOCALPARAM KW_REAL list_of_param_assignments
                              SEMICOLON
                            | KW_LOCALPARAM KW_REALTIME 
                              list_of_param_assignments SEMICOLON
                            | KW_LOCALPARAM KW_TIME list_of_param_assignments
                              SEMICOLON
                            ;

parameter_declaration : KW_PARAMETER signed_o range_o 
                        list_of_param_assignments SEMICOLON
                      | KW_PARAMETER KW_INTEGER list_of_param_assignments
                        SEMICOLON
                      | KW_PARAMETER KW_REAL list_of_param_assignments
                        SEMICOLON
                      | KW_PARAMETER KW_REALTIME list_of_param_assignments
                        SEMICOLON
                      | KW_PARAMETER KW_TIME list_of_param_assignments
                        SEMICOLON
                      ;

specparam_declaration : KW_SPECPARAM range_o list_of_specparam_assignments
                        SEMICOLON
                      ;

/* A.2.1.2 Port declarations */

net_type_o  : net_type | ;
reg_o       : KW_REG   {$$=1;}| {$$=0;};

inout_declaration : KW_INOUT net_type_o signed_o range_o 
                    list_of_port_identifiers
                  ;

input_declaration : KW_INPUT net_type_o signed_o range_o 
                    list_of_port_identifiers
                  ;

output_declaration: 
  KW_OUTPUT net_type_o signed_o range_o list_of_port_identifiers
| KW_OUTPUT reg_o signed_o range_o list_of_port_identifiers
| KW_OUTPUT output_variable_type_o list_of_port_identifiers
| KW_OUTPUT output_variable_type list_of_variable_port_identifiers
| KW_OUTPUT KW_REG signed_o range_o list_of_variable_port_identifiers
                  ;

/* A.2.1.3 Type declarations */

event_declaration   : KW_EVENT list_of_event_identifiers SEMICOLON ;
genvar_declaration  : KW_GENVAR list_of_genvar_identifiers SEMICOLON ;
integer_declaration : KW_INTEGER list_of_variable_identifiers SEMICOLON ;


delay3_o            : delay3 | ;
drive_strength_o    : drive_strength | ;

net_declaration : net_type                  net_dec_p_ds
                | net_type  drive_strength  net_dec_p_ds
                | KW_TRIREG                 net_dec_p_ds
                | KW_TRIREG drive_strength  net_dec_p_ds
                | KW_TRIREG charge_strength net_dec_p_ds
                ;

net_dec_p_ds    : KW_VECTORED                   net_dec_p_vs
                | KW_SCALARED                   net_dec_p_vs
                | net_dec_p_vs
                ;

net_dec_p_vs    : KW_SIGNED                     net_dec_p_si
                | net_dec_p_si
                ;

net_dec_p_si    : range                         net_dec_p_range
                | net_dec_p_range
                ;

net_dec_p_range : delay3                        net_dec_p_delay
                | net_dec_p_delay
                ;

net_dec_p_delay : list_of_net_identifiers       SEMICOLON
                | list_of_net_decl_assignments  SEMICOLON
                ;


real_declaration    : KW_REAL list_of_real_identifiers SEMICOLON ;

realtime_declaration: KW_REALTIME list_of_real_identifiers SEMICOLON ;

reg_declaration     : KW_REG KW_SIGNED reg_dec_p_signed
                    | KW_REG reg_dec_p_signed
                    ;

reg_dec_p_signed    : range reg_dec_p_range
                    | reg_dec_p_range
                    ;

reg_dec_p_range     : list_of_variable_identifiers SEMICOLON
                    ;

time_declaration    : KW_TIME list_of_variable_identifiers SEMICOLON ;

/* 2.2.1 Net and variable types */

net_type            : KW_SUPPLY0 | KW_SUPPLY1 | KW_TRI  | KW_TRIAND | 
                      KW_TRIOR   | KW_WIRE    | KW_WAND | KW_WOR
                    ;

output_variable_type_o : output_variable_type | ;
output_variable_type: KW_INTEGER
                    | KW_TIME
                    ;

real_type           : real_identifier 
                    | real_identifier EQ constant_expression
                    | real_identifier dimension dimensions
                    ;

dimensions          : dimension
                    | dimensions dimension
                    |
                    ;

variable_type       : variable_identifier 
                    | variable_identifier EQ constant_expression
                    | variable_identifier dimension dimensions
                    ;

/* A.2.2.2 Strengths */

drive_strength      : strength0 COMMA strength1 CLOSE_BRACKET
                    | strength1 COMMA strength0 CLOSE_BRACKET
                    | strength0 COMMA KW_HIGHZ1 CLOSE_BRACKET
                    | strength1 COMMA KW_HIGHZ0 CLOSE_BRACKET
                    | KW_HIGHZ0 COMMA strength1 CLOSE_BRACKET
                    | KW_HIGHZ1 COMMA strength0 CLOSE_BRACKET
                    ;

strength0           : KW_SUPPLY0 | KW_STRONG0 | KW_PULL0 | KW_WEAK0 ;
strength1           : KW_SUPPLY1 | KW_STRONG1 | KW_PULL1 | KW_WEAK1 ;

charge_strength     : OPEN_BRACKET KW_SMALL CLOSE_BRACKET
                    | OPEN_BRACKET KW_MEDIUM CLOSE_BRACKET
                    | OPEN_BRACKET KW_LARGE CLOSE_BRACKET
                    ;

/* A.2.2.3 Delays */

delay3              : HASH delay_value
                    | HASH OPEN_BRACKET delay_value CLOSE_BRACKET
                    | HASH OPEN_BRACKET delay_value COMMA delay_value 
                      CLOSE_BRACKET
                    | HASH OPEN_BRACKET delay_value COMMA delay_value COMMA 
                      delay_value CLOSE_BRACKET
                    |
                    ;

delay2              : HASH delay_value
                    | HASH OPEN_BRACKET delay_value CLOSE_BRACKET
                    | HASH OPEN_BRACKET delay_value COMMA delay_value 
                      CLOSE_BRACKET
                    |
                    ;

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
                          | list_of_event_identifiers COMMA event_identifier 
                            dimensions_o
                          ;

list_of_genvar_identifiers: genvar_identifier
                          : list_of_genvar_identifiers COMMA genvar_identifier
                          ;

list_of_net_decl_assignments : net_decl_assignment
                             | list_of_net_decl_assignments COMMA 
                               net_decl_assignment
                             ;

list_of_net_identifiers      : net_identifier dimensions_o
                             | list_of_net_identifiers COMMA net_identifier
                               dimensions_o
                             ;

list_of_param_assignments    : param_assignment
                             | list_of_param_assignments COMMA param_assignment
                             ;

list_of_port_identifiers     : port_identifier
                             | list_of_port_identifiers COMMA port_identifier
                             ;

list_of_real_identifiers     : real_type
                             | list_of_real_identifiers COMMA real_type
                             ;

list_of_specparam_assignments: specparam_assignment
                             | list_of_specparam_assignments COMMA 
                               specparam_assignment
                             ;

list_of_variable_identifiers : variable_type
                             | list_of_variable_identifiers COMMA variable_type
                             ;

eq_const_exp_o               : EQ constant_expression
                             |
                             ;

list_of_variable_port_identifiers : port_identifier eq_const_exp_o
                                  | list_of_variable_port_identifiers COMMA 
                                    port_identifier eq_const_exp_o
                                  ;

/* A.2.4 Declaration Assignments */

net_decl_assignment     : net_identifier EQ expression  
                        | net_identifier               
                        ;

param_assignment        : parameter_identifier EQ constant_expression ;

specparam_assignment    : specparam_identifier EQ 
                          constant_mintypmax_expression
                        | pulse_control_specparam
                        ;

error_limit_value_o     : COMMA error_limit_value
                        |
                        ;

pulse_control_specparam : KW_PATHPULSE EQ OPEN_BRACKET reject_limit_value 
                          error_limit_value_o CLOSE_BRACKET SEMICOLON
                        | KW_PATHPULSE specify_input_terminal_descriptor '$'
                          specify_output_terminal_descriptor EQ OPEN_BRACKET 
                          reject_limit_value error_limit_value_o CLOSE_BRACKET SEMICOLON
                        ;

error_limit_value       : limit_value ;
reject_limit_value      : limit_value ;
limit_value             : constant_mintypmax_expression ;

/* A.2.5 Declaration ranges */

dimension               : OPEN_SQ_BRACKET constant_expression COLON 
                           constant_expression CLOSE_SQ_BRACKET ;

range                   : OPEN_SQ_BRACKET constant_expression COLON 
                           constant_expression CLOSE_SQ_BRACKET 
                        ;

/* A.2.6 Function Declarations */

automatic_o         : KW_AUTOMATIC | ;

function_declaration : KW_FUNCTION automatic_o signed_o range_or_type
                       function_identifier SEMICOLON function_item_declarations
                       function_statement KW_ENDFUNCTION
                     | KW_FUNCTION automatic_o signed_o range_or_type
                       function_identifier OPEN_BRACKET function_port_list CLOSE_BRACKET SEMICOLON 
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
                           | tf_input_declaration SEMICOLON
                           ;

function_port_list         : attribute_instances tf_input_declaration
                             tf_input_declarations;

tf_input_declarations      : 
                           | COMMA attribute_instances tf_input_declaration
                             tf_input_declarations
                           ;

range_or_type              : range
                           | KW_INTEGER
                           | KW_REAL
                           | KW_REALTIME
                           | KW_TIME
                           ;

/* A.2.7 Task Declarations */

task_declaration    : KW_TASK automatic_o task_identifier SEMICOLON
                      task_item_declarations
                      statement
                      KW_ENDTASK
                    | KW_TASK automatic_o task_identifier 
                      OPEN_BRACKET task_port_list CLOSE_BRACKET SEMICOLON
                      block_item_declarations
                      statement
                      KW_ENDTASK
                    ;

task_item_declarations : task_item_declaration
                       | task_item_declarations task_item_declaration
                       ;

task_item_declaration : block_item_declaration
                      | attribute_instances tf_input_declaration SEMICOLON
                      | attribute_instances tf_output_declaration SEMICOLON
                      | attribute_instances tf_inout_declaration SEMICOLON
                      ;

task_port_list  : task_port_item
                | task_port_list COMMA task_port_item
                ;

task_port_item  : attribute_instances tf_input_declaration SEMICOLON
                | attribute_instances tf_output_declaration SEMICOLON
                | attribute_instances tf_inout_declaration SEMICOLON

tf_input_declaration : KW_INPUT reg_o signed_o range_o list_of_port_identifiers
                     | KW_INPUT task_port_type_o list_of_port_identifiers
                     ;

tf_output_declaration : KW_OUTPUT reg_o signed_o range_o list_of_port_identifiers
                      | KW_OUTPUT task_port_type_o list_of_port_identifiers
                      ;

tf_inout_declaration : KW_INOUT reg_o signed_o range_o list_of_port_identifiers
                     | KW_INOUT task_port_type_o list_of_port_identifiers
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
                        list_of_block_variable_identifiers SEMICOLON
                      ;

list_of_block_variable_identifiers : block_variable_type
                                   | list_of_block_variable_identifiers COMMA 
                                     block_variable_type
                                   ;

block_variable_type : variable_identifier
                    | variable_identifier dimensions
                    ;

/* A.3.1 primitive instantiation and instances */

delay2_o : delay2 | ;

gate_instantiation      : cmos_switchtype cmos_switch_instances SEMICOLON
                        | gate_enable SEMICOLON
                        | mos_switchtype mos_switch_instances SEMICOLON
                        | gate_n_output SEMICOLON /* TESTING */
                        | gate_pass_en_switch SEMICOLON
                        | gate_n_input SEMICOLON
                        | pass_switchtype 
                          pass_switch_instances SEMICOLON
                        | KW_PULLDOWN pulldown_strength_o pull_gate_instances 
                          SEMICOLON
                        | KW_PULLUP pullup_strength_o pull_gate_instances 
                          SEMICOLON
                        ;

/* -------------------------------------------------------------------------*/

OB : OPEN_BRACKET;
CB : CLOSE_BRACKET;

gate_n_output : gatetype_n_output n_output_gate_instances
              | gatetype_n_output OB drive_strength gate_n_output_a_ds
              | gatetype_n_output OB output_terminal COMMA gate_n_output_a_ot 
              | gatetype_n_output delay2 n_output_gate_instances 
              ;

gate_n_output_a_ds  : delay2 n_output_gate_instances
                    | n_output_gate_instances
                    ;

gate_n_output_a_id  : 
                    | COMMA n_output_gate_instances
                    ;

gate_n_output_a_ot  : input_terminal CB gate_n_output_a_id
                    | output_terminals COMMA input_terminal CB gate_n_output_a_id
                    ;

gatetype_n_output       : KW_BUF
                        | KW_NOT
                        ;

n_output_gate_instances : n_output_gate_instance
                        | n_output_gate_instances COMMA 
                          n_output_gate_instance
                        ;

n_output_gate_instance  : name_of_gate_instance OPEN_BRACKET 
                          output_terminals COMMA
                          input_terminal CLOSE_BRACKET
                        ;

/* -------------------------------------------------------------------------*/

gate_enable : enable_gatetype enable_gate_instances
            | enable_gatetype OB drive_strength gate_n_output_a_ds
            | enable_gatetype OB output_terminal COMMA input_terminal COMMA 
              enable_terminal CB gate_n_output_a_id
            | enable_gatetype delay3 enable_gate_instances
            ;

enable_gate_instances : enable_gate_instance
                      | enable_gate_instances COMMA enable_gate_instance 
                      ;

enable_gate_instance  : name_of_gate_instance OPEN_BRACKET 
                        output_terminal COMMA
                        input_terminal COMMA enable_terminal 
                        CLOSE_BRACKET
                      ;

enable_gatetype     : KW_BUFIF0 
                    | KW_BUFIF1 
                    | KW_NOTIF0 
                    | KW_NOTIF1 
                    ;

/* -------------------------------------------------------------------------*/

gate_n_input : gatetype_n_input n_input_gate_instances
             | gatetype_n_input OB drive_strength gate_n_input_a_ds
             | gatetype_n_input OB input_terminals COMMA input_terminal CB gate_n_input_a_id
             | gatetype_n_input delay2 n_input_gate_instances 
             ;

gate_n_input_a_ds  : delay2 n_input_gate_instances
                   | n_input_gate_instances
                   ;

gate_n_input_a_id  : 
                   | COMMA n_input_gate_instances
                   ;

n_input_gate_instances : n_input_gate_instance
                       | n_input_gate_instances COMMA 
                         n_input_gate_instance
                       ;

n_input_gate_instance  : name_of_gate_instance OPEN_BRACKET 
                         output_terminal COMMA
                         input_terminals CLOSE_BRACKET
                       ;

gatetype_n_input    : KW_AND  
                    | KW_NAND  
                    | KW_OR   
                    | KW_NOR  
                    | KW_XOR  
                    | KW_XNOR 
                    ;

/* -------------------------------------------------------------------------*/

gate_pass_en_switch : pass_en_switchtype pass_enable_switch_instances
                    ;

pass_enable_switch_instances : pass_enable_switch_instance
                             | pass_enable_switch_instances COMMA 
                               pass_enable_switch_instance
                             ;

pass_en_switchtype  : KW_TRANIF0  delay2
                    | KW_TRANIF1  delay2
                    | KW_RTRANIF1 delay2 
                    | KW_RTRANIF0 delay2
                    ;


pass_enable_switch_instance  : name_of_gate_instance OPEN_BRACKET inout_terminal COMMA
                               inout_terminal COMMA enable_terminal CLOSE_BRACKET
                             ;


/* -------------------------------------------------------------------------*/

pull_gate_instances : pull_gate_instance
                    | pull_gate_instances COMMA 
                      pull_gate_instance
                    ;

pass_switch_instances : pass_switch_instance
                      | pass_switch_instances COMMA 
                        pass_switch_instance
                      ;

n_input_gate_instances : n_input_gate_instance
                       | n_input_gate_instances COMMA n_input_gate_instance
                       ;

mos_switch_instances : mos_switch_instance
                     | mos_switch_instances COMMA mos_switch_instance
                     ;

cmos_switch_instances : cmos_switch_instance
                      | cmos_switch_instances COMMA cmos_switch_instance
                      ;


pull_gate_instance           : name_of_gate_instance OPEN_BRACKET 
                               output_terminal CLOSE_BRACKET
                             ;

pass_switch_instance         : name_of_gate_instance OPEN_BRACKET 
                               inout_terminal COMMA
                               inout_terminal CLOSE_BRACKET
                             ;


n_input_gate_instance        : name_of_gate_instance OPEN_BRACKET 
                               output_terminal COMMA
                               input_terminals CLOSE_BRACKET
                             ;

mos_switch_instance          : name_of_gate_instance OPEN_BRACKET 
                               output_terminal COMMA
                               input_terminal COMMA enable_terminal 
                               CLOSE_BRACKET       
                             ;

cmos_switch_instance         : name_of_gate_instance OPEN_BRACKET 
                               output_terminal COMMA
                               input_terminal COMMA ncontrol_terminal COMMA
                               pcontrol_terminal CLOSE_BRACKET
                             ;

output_terminals             : output_terminals COMMA output_terminal
                             | output_terminal
                             ;

input_terminals              : input_terminal
                             | input_terminals COMMA input_terminal
                             ;

/* A.3.2 primitive strengths */

pulldown_strength_o : pulldown_strength | ;
pulldown_strength           : OPEN_BRACKET strength0 COMMA strength1 CLOSE_BRACKET
                            | OPEN_BRACKET strength1 COMMA strength0 CLOSE_BRACKET
                            | OPEN_BRACKET strength1 CLOSE_BRACKET
                            ;

pullup_strength_o : pullup_strength | ;
pullup_strength             : OPEN_BRACKET strength0 COMMA strength1 CLOSE_BRACKET
                            | OPEN_BRACKET strength1 COMMA strength0 CLOSE_BRACKET
                            | OPEN_BRACKET strength1 CLOSE_BRACKET
                            ;


name_of_gate_instance   : 
                        | gate_instance_identifier range_o
                        ;

/* A.3.3 primitive terminals */

enable_terminal     : expression;
inout_terminal      : net_lvalue;
input_terminal      : expression;
ncontrol_terminal   : expression;
output_terminal     : expression; /* Deliberate bug. should be net_lvalue, implement with semantic checking later. */
pcontrol_terminal   : expression;

/* A.3.4 primitive gate and switch types */

cmos_switchtype     : KW_CMOS  delay3
                    | KW_RCMOS delay3
                    ;

mos_switchtype      : KW_NMOS  delay3
                    | KW_PMOS  delay3
                    | KW_RNMOS delay3 
                    | KW_RPMOS delay3
                    ;

pass_switchtype     : KW_TRAN  delay2
                    | KW_RTRAN delay2
                    ;

/* A.4.1 module instantiation */

module_instantiation: module_identifier parameter_value_assignment_o
                      module_instances SEMICOLON
                    ;

parameter_value_assignment_o : parameter_value_assignment | ;

parameter_value_assignment : HASH OPEN_BRACKET list_of_parameter_assignments
                             CLOSE_BRACKET
                           ;

list_of_parameter_assignments : ordered_parameter_assignments
                              | named_parameter_assignments
                              ;

ordered_parameter_assignments : ordered_parameter_assignment
                              | ordered_parameter_assignments COMMA
                                ordered_parameter_assignment
                              ;
named_parameter_assignments   : named_parameter_assignment
                              | named_parameter_assignments COMMA
                                named_parameter_assignment
                              ;

module_instances : module_instance
                 | module_instances COMMA module_instance
                 ;

ordered_parameter_assignment : expression;

named_parameter_assignment : DOT parameter_identifier OPEN_BRACKET 
                             expression_o CLOSE_BRACKET 
                           ;

module_instance : name_of_instance OPEN_BRACKET 
                  list_of_port_connections 
                  CLOSE_BRACKET
                ;

name_of_instance : module_instance_identifier range_o 
                 ;

list_of_port_connections :
                         | ordered_port_connections
                         | named_port_connections
                         ;

ordered_port_connections : ordered_port_connection
                         | ordered_port_connections
                           COMMA
                           ordered_port_connection
                         ;

named_port_connections   : named_port_connection 
                         | named_port_connections COMMA
                           named_port_connection
                         ;

ordered_port_connection : attribute_instances 
                          expression_o
                        ;

named_port_connection : DOT port_identifier
                        OPEN_BRACKET expression_o CLOSE_BRACKET
                      ;

expression_o : expression  | ;

/* A.4.2 Generated instantiation */

generated_instantiation : KW_GENERATE generate_items KW_ENDGENERATE ;

generate_items : generate_item
               | generate_items generate_item
               ;

generate_item_or_null: generate_item | ;

generate_item : generate_conditional_statement
              | generate_case_statement
              | generate_loop_statement
              | generate_block
              | module_or_generate_item
              ;

generate_conditional_statement : KW_IF OPEN_BRACKET constant_expression CLOSE_BRACKET
                                 generate_item_or_null KW_ELSE
                                 generate_item_or_null
                               | KW_IF OPEN_BRACKET constant_expression CLOSE_BRACKET
                                 generate_item_or_null
                               ;

generate_case_statement : KW_CASE OPEN_BRACKET constant_expression CLOSE_BRACKET
                          genvar_case_items KW_ENDCASE
                        ;

genvar_case_items : genvar_case_item
                  | genvar_case_items genvar_case_item
                  |
                  ;

genvar_case_item : constant_expressions COLON 
                 | KW_DEFAULT COLON 
                 | KW_DEFAULT     
                 ;

generate_loop_statement : KW_FOR OPEN_BRACKET genvar_assignment SEMICOLON constant_expression
                          SEMICOLON genvar_assignment CLOSE_BRACKET KW_BEGIN SEMICOLON
                          generate_block_identifier generate_items KW_END

genvar_assignment : genvar_identifier EQ constant_expression;

generate_block : KW_BEGIN generate_items KW_END
               | KW_BEGIN COLON generate_block_identifier generate_items KW_END
               ;

/* A.5.1 UDP Declaration */

udp_declaration : attribute_instances KW_PRIMITIVE udp_identifier
                  OPEN_BRACKET udp_port_list CLOSE_BRACKET SEMICOLON
                  udp_port_declarations udp_body KW_ENDPRIMITIVE
                | attribute_instances KW_PRIMITIVE udp_identifier
                  OPEN_BRACKET udp_declaration_port_list CLOSE_BRACKET SEMICOLON
                  udp_body KW_ENDPRIMITIVE
                ;

udp_port_declarations : udp_port_declaration
                      | udp_port_declarations udp_port_declaration
                      ;

/* A.5.2 UDP Ports */

udp_port_list : output_port_identifier COMMA input_port_identifiers;

input_port_identifiers : input_port_identifier
                       | input_port_identifiers COMMA input_port_identifier
                       ;

udp_declaration_port_list : udp_output_declaration COMMA udp_input_declarations;

udp_input_declarations  : udp_input_declaration
                        | udp_input_declarations udp_input_declaration
                        ;

udp_port_declaration : udp_output_declaration SEMICOLON
                     | udp_input_declaration SEMICOLON
                     | udp_reg_declaration SEMICOLON
                     ;

udp_output_declaration : attribute_instances KW_OUTPUT port_identifier
                       | attribute_instances KW_OUTPUT KW_REG 
                         port_identifier
                       | attribute_instances KW_OUTPUT KW_REG 
                         port_identifier EQ constant_expression
                       ;

udp_input_declaration : attribute_instances KW_INPUT list_of_port_identifiers
                      ;

udp_reg_declaration : attribute_instances KW_REG variable_identifier
                    ;

/* A.5.3 UDP body */

udp_body            : combinational_body 
                    | sequential_body
                    ;

combinational_body  : KW_TABLE combinational_entrys KW_ENDTABLE;

combinational_entrys : combinational_entry
                     | combinational_entrys combinational_entry
                     ;

combinational_entry : level_input_list COLON output_symbol SEMICOLON ;

sequential_body : udp_initial_statement KW_TABLE sequential_entrys KW_ENDTABLE
                | KW_TABLE sequential_entrys KW_ENDTABLE
                ;

sequential_entrys     : sequential_entry
                      | sequential_entrys sequential_entry
                      ;

udp_initial_statement : KW_INITIAL output_port_identifier EQ init_val SEMICOLON;

init_val              : '1' '\'' 'b' '0' 
                      | '1' '\'' 'b' '1' 
                      | '1' '\'' 'b' 'x' 
                      | '1' '\'' 'b' 'X' 
                      | '1' '\'' 'B' '0' 
                      | '1' '\'' 'B' '1' 
                      | '1' '\'' 'B' 'x' 
                      | '1' '\'' 'B' 'X' 
                      | '1'    
                      | '0'
                      ;

sequential_entry      : seq_input_list COLON current_state COLON next_state SEMICOLON;
seq_input_list        : level_input_list | edge_input_list;

level_input_list      : level_symbols;

level_symbols_o       : level_symbols | ;
level_symbols         : level_symbol
                      | level_symbols level_symbol
                      ;

edge_input_list       :  level_symbols_o edge_indicator level_symbols_o;

edge_indicator        : OPEN_BRACKET level_symbol level_symbol CLOSE_BRACKET 
                      | edge_symbol
                      ;

current_state         : level_symbol;

next_state            : output_symbol | '-'
                      ;

output_symbol : '0' | '1' | 'x' | 'X';

level_symbol :'0'|'1'|'x'|'X'|'?'|'b'|'B';

edge_symbol :'r'|'R'|'f'|'F'|'p'|'P'|'n'|'N'|STAR;

/* A.5.4 UDP instantiation */

udp_instantiation : udp_identifier drive_strength_o delay2_o udp_instances SEMICOLON
                  ;

udp_instances : udp_instance
              | udp_instances COMMA udp_instance
              ;

udp_instance : name_of_udp_instance OPEN_BRACKET output_terminal COMMA input_terminals CLOSE_BRACKET
             | OPEN_BRACKET output_terminal COMMA input_terminals CLOSE_BRACKET
             ;
name_of_udp_instance : udp_instance_identifier range_o SEMICOLON ;

/* A.6.1 Continuous assignment statements */

continuous_assign : KW_ASSIGN drive_strength_o delay3_o 
                    list_of_net_assignments SEMICOLON
                  ;

list_of_net_assignments : net_assignment
                        | list_of_net_assignments COMMA net_assignment
                        ;

net_assignment : net_lvalue EQ expression;

/* A.6.2 Procedural blocks and assignments */

initial_construct   : KW_INITIAL statement ;
always_construct    : KW_ALWAYS statement ;

blocking_assignment : variable_lvalue EQ delay_or_event_control_o expression;
nonblocking_assignment : variable_lvalue LTE delay_or_event_control_o 
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

function_blocking_assignment : variable_lvalue SEMICOLON expression
                             ;

function_statement_or_null : function_statement
                           | attribute_instances SEMICOLON
                           ;

/* A.6.3 Parallel and sequential blocks */

block_item_declarations     : block_item_declaration
                            | block_item_declarations block_item_declaration
                            ;

function_statements_o   : function_statements | ;
function_statements     : function_statement
                        | function_statements function_statement
                        ;

function_seq_block : KW_BEGIN function_statements_o KW_END
                   | KW_BEGIN COLON block_identifier block_item_declarations
                     function_statements_o KW_END
                   ;

variable_assignment : variable_lvalue EQ expression
                    ;

par_block : KW_FORK statements_o KW_JOIN
          | KW_FORK COLON block_identifier block_item_declarations statements_o
            KW_JOIN
          ;

seq_block : KW_BEGIN statements_o KW_END
          | KW_BEGIN COLON block_identifier block_item_declarations 
            statements_o KW_END
          ;

/* A.6.4 Statements */

statements_o : statements | ;
statements   : statement
             | statements statement
             ;

statement : attribute_instances blocking_assignment SEMICOLON
          | attribute_instances nonblocking_assignment SEMICOLON
          | attribute_instances case_statement
          | attribute_instances conditional_statement
          | attribute_instances disable_statement
          | attribute_instances event_trigger
          | attribute_instances loop_statement
          | attribute_instances par_block
          | attribute_instances procedural_continuous_assignments SEMICOLON
          | attribute_instances procedural_timing_control_statement
          | attribute_instances seq_block
          | attribute_instances system_function_call SEMICOLON
          | attribute_instances system_task_enable
          | attribute_instances task_enable
          | attribute_instances wait_statement
          ;

statement_or_null : statement
                  | attribute_instances SEMICOLON
                  ;
                  
function_statement : attribute_instances function_blocking_assignment SEMICOLON
                   | attribute_instances function_case_statement
                   | attribute_instances function_conditional_statement
                   | attribute_instances function_loop_statement
                   | attribute_instances function_seq_block
                   | attribute_instances disable_statement
                   | attribute_instances system_function_call SEMICOLON
                   | attribute_instances system_task_enable
                   ;

/* A.6.5 Timing control statements */

delay_control : HASH delay_value
              | HASH OPEN_BRACKET mintypmax_expression CLOSE_BRACKET
              ;

delay_or_event_control : delay_control
                       | event_control
                       | KW_REPEAT OPEN_BRACKET expression CLOSE_BRACKET event_control
                       ;

disable_statement : KW_DISABLE hierarchical_task_identifier SEMICOLON
                  | KW_DISABLE hierarchical_block_identifier SEMICOLON
                  ;

event_control : AT  event_identifier
              | AT  OPEN_BRACKET event_expression CLOSE_BRACKET
              | AT STAR
              | AT  ATTRIBUTE_START CLOSE_BRACKET /* Add attribute_start here since the tokeniser may return it an it still be valid.*/
              | AT  OPEN_BRACKET STAR CLOSE_BRACKET
              ;

event_trigger : MINUS GT hierarchical_event_identifier ;

event_expression : expression
                 | hierarchical_identifier
                 | KW_POSEDGE expression
                 | KW_NEGEDGE expression
                 | event_expression KW_OR event_expression
                 | event_expression COMMA event_expression

procedural_timing_control_statement : delay_or_event_control statement_or_null

wait_statement : KW_WAIT OPEN_BRACKET expression CLOSE_BRACKET statement_or_null;

/* A.6.6 Conditional Statemnets */

conditional_statement : if_else_if_statement
                      | KW_IF OPEN_BRACKET expression CLOSE_BRACKET 
                        statement_or_null
                      | KW_IF OPEN_BRACKET expression CLOSE_BRACKET 
                        statement_or_null KW_ELSE statement_or_null
                      ;

if_else_if_statement : KW_IF OPEN_BRACKET expression CLOSE_BRACKET 
                       statement_or_null else_if_statements
                     | KW_IF OPEN_BRACKET expression CLOSE_BRACKET 
                       statement_or_null else_if_statements
                       KW_ELSE statement_or_null
                     ;

else_if_statements : KW_ELSE KW_IF OPEN_BRACKET expression CLOSE_BRACKET 
                     statement_or_null
                   | else_if_statements KW_ELSE KW_IF OPEN_BRACKET expression
                     CLOSE_BRACKET statement_or_null
                   ;

function_conditional_statement : KW_IF OPEN_BRACKET expression CLOSE_BRACKET 
                                 function_statement_or_null
                               | KW_IF OPEN_BRACKET expression CLOSE_BRACKET 
                                 function_statement_or_null
                                 KW_ELSE function_statement_or_null
                               | function_if_else_if_statement
                               ;

function_else_if_statements   : KW_ELSE KW_IF OPEN_BRACKET expression 
                                CLOSE_BRACKET function_statement_or_null 
                              | function_else_if_statements KW_ELSE KW_IF 
                                OPEN_BRACKET expression CLOSE_BRACKET 
                                function_statement_or_null
                              ;

function_if_else_if_statement : KW_IF OPEN_BRACKET expression CLOSE_BRACKET 
                                function_statement_or_null
                                function_else_if_statements
                              | KW_IF OPEN_BRACKET expression CLOSE_BRACKET 
                                function_statement_or_null
                                function_else_if_statements
                                KW_ELSE function_statement_or_null
                              ;

/* A.6.7 Case Statements */

case_statement  : KW_CASE OPEN_BRACKET expression CLOSE_BRACKET case_items KW_ENDCASE
                | KW_CASEZ OPEN_BRACKET expression CLOSE_BRACKET case_items KW_ENDCASE
                | KW_CASEX OPEN_BRACKET expression CLOSE_BRACKET case_items KW_ENDCASE
                ;

case_items      : case_item
                | case_items case_item
                ;

expressions_o   : expressions | ;


case_item       : expressions COLON statement_or_null
                | KW_DEFAULT statement_or_null
                | KW_DEFAULT COLON statement_or_null
                ;

function_case_statement : KW_CASE OPEN_BRACKET expression CLOSE_BRACKET  function_case_items 
                          KW_ENDCASE
                        | KW_CASEZ OPEN_BRACKET expression CLOSE_BRACKET function_case_items 
                          KW_ENDCASE
                        | KW_CASEX OPEN_BRACKET expression CLOSE_BRACKET function_case_items 
                          KW_ENDCASE
                        ;

function_case_items     : function_case_item
                        | function_case_items case_item
                        ;

function_case_item      : expressions COLON function_statement_or_null
                        | KW_DEFAULT function_statement_or_null
                        | KW_DEFAULT COLON function_statement_or_null
                        ;

/* A.6.8 looping statements */

function_loop_statement : KW_FOREVER function_statement
                        | KW_REPEAT OPEN_BRACKET expression CLOSE_BRACKET function_statement
                        | KW_WHILE OPEN_BRACKET expression CLOSE_BRACKET function_statement
                        | KW_FOR OPEN_BRACKET variable_assignment SEMICOLON expression
                          SEMICOLON variable_assignment  CLOSE_BRACKET function_statement
                        ;

loop_statement          : KW_FOREVER statement
                        | KW_REPEAT OPEN_BRACKET expression CLOSE_BRACKET statement
                        | KW_WHILE OPEN_BRACKET expression CLOSE_BRACKET statement
                        | KW_FOR OPEN_BRACKET variable_assignment SEMICOLON expression
                          SEMICOLON variable_assignment  CLOSE_BRACKET statement
                        ;


/* A.6.9 task enable statements */

system_task_enable      : system_task_identifier expressions_o SEMICOLON ;

task_enable             : hierarchical_task_identifier expressions_o SEMICOLON ;

/* A.7.1 specify block declaration */

specify_block           : KW_SPECIFY specify_items_o KW_ENDSPECIFY;

specify_items_o         : specify_items | ;

specify_items           : specify_item
                        | specify_items specify_item
                        ;

specify_item            : specparam_declaration
                        | pulsestyle_declaration
                        | showcancelled_declaration
                        | path_declaration
                        | system_timing_check {printf("%s:%d: System Timing check not supported\n", __FILE__, __LINE__);}
                        ;

pulsestyle_declaration  : KW_PULSESTYLE_ONEVENT list_of_path_outputs SEMICOLON
                        | KW_PULSESTYLE_ONDETECT list_of_path_outputs SEMICOLON
                        ;

showcancelled_declaration   : KW_SHOWCANCELLED list_of_path_outputs SEMICOLON
                            | KW_NOSHOWCANCELLED list_of_path_outputs SEMICOLON
                            ;

/* A.7.2 specify path declarations */

path_declaration : simple_path_declaration SEMICOLON
                 | edge_sensitive_path_declaration SEMICOLON
                 | state_dependent_path_declaration SEMICOLON
                 ;

simple_path_declaration : parallel_path_description EQ path_delay_value
                        | full_path_description EQ path_delay_value
                        ;

parallel_path_description : OPEN_BRACKET specify_input_terminal_descriptor
                            polarity_operator_o EQ GT
                            specify_output_terminal_descriptor CLOSE_BRACKET
                          ;

polarity_operator_o : polarity_operator | ;

full_path_description : OPEN_BRACKET list_of_path_inputs polarity_operator_o 
                        STAR GT list_of_path_outputs CLOSE_BRACKET
                      ;

list_of_path_inputs   : specify_input_terminal_descriptor
                      | list_of_path_inputs COMMA 
                        specify_input_terminal_descriptor
                      ;

list_of_path_outputs  : specify_output_terminal_descriptor
                      | list_of_path_outputs COMMA 
                        specify_output_terminal_descriptor
                      ;

/* A.7.3 specify block terminals */

specify_input_terminal_descriptor : input_identifier
                                  | input_identifier constant_expression_o
                                  | input_identifier range_expression_o
                                  ;

specify_output_terminal_descriptor : output_identifier
                                   | output_identifier constant_expression_o
                                   | output_identifier range_expression_o
                                   ;

constant_expression_o : constant_expression | ;
range_expression_o : range_expression | ;

input_identifier : input_port_identifier
                 | inout_port_identifier
                 ;

output_identifier : output_port_identifier 
                  | inout_port_identifier
                  ;

/* A.7.4 specify path delays */

path_delay_value : list_of_path_delay_expressions
                 | OPEN_BRACKET list_of_path_delay_expressions CLOSE_BRACKET
                 ;

list_of_path_delay_expressions : path_delay_expression
                               | path_delay_expression COMMA
                                 path_delay_expression 
                               | path_delay_expression COMMA
                                 path_delay_expression COMMA
                                 path_delay_expression
                               | path_delay_expression COMMA
                                 path_delay_expression COMMA
                                 path_delay_expression COMMA
                                 path_delay_expression COMMA
                                 path_delay_expression COMMA
                                 path_delay_expression
                               | path_delay_expression COMMA
                                 path_delay_expression COMMA
                                 path_delay_expression COMMA
                                 path_delay_expression COMMA
                                 path_delay_expression COMMA
                                 path_delay_expression
                                 path_delay_expression COMMA
                                 path_delay_expression COMMA
                                 path_delay_expression COMMA
                                 path_delay_expression COMMA
                                 path_delay_expression COMMA
                                 path_delay_expression
                               ;

path_delay_expression : constant_mintypmax_expression ;

edge_sensitive_path_declaration : parallel_edge_sensitive_path_description EQ
                                  path_delay_value
                                | full_edge_sensitive_path_description EQ 
                                  path_delay_value
                                ;

parallel_edge_sensitive_path_description : OPEN_BRACKET edge_identifier_o 
                                           specify_input_terminal_descriptor 
                                           EQ GT
                                           specify_output_terminal_descriptor 
                                           polarity_operator_o COLON 
                                           data_source_expression CLOSE_BRACKET

full_edge_sensitive_path_description : OPEN_BRACKET edge_identifier_o 
                                       list_of_path_inputs STAR GT
                                       list_of_path_outputs polarity_operator_o
                                       COLON data_source_expression CLOSE_BRACKET
                                     ;

data_source_expression : expression ;

edge_identifier_o : edge_identifier | ;
edge_identifier : KW_POSEDGE | KW_NEGEDGE;

state_dependent_path_declaration : KW_IF OPEN_BRACKET module_path_expression CLOSE_BRACKET 
                                   simple_path_declaration
                                 | KW_IF OPEN_BRACKET module_path_expression CLOSE_BRACKET 
                                   edge_sensitive_path_declaration
                                 | KW_IFNONE simple_path_declaration
                                 ;

polarity_operator_o : polarity_operator | ;
polarity_operator : PLUS | MINUS ;

/* A.7.5.1 System timing check commands */

system_timing_check : {printf("%s:%d Not Supported\n",__FILE__,__LINE__);};

/* A.7.5.2 System timing check command arguments */

/* A.7.5.3 System timing check evet definitions */

/* A.8.1 Concatenations */

concatenation : 
  OPEN_SQ_BRACE expression concatenation_cont
;

concatenation_cont :
  CLOSE_SQ_BRACE
| COMMA expression concatenation_cont
;


constant_concatenation : 
  OPEN_SQ_BRACE expression constant_concatenation_cont
;

constant_concatenation_cont : 
  CLOSE_SQ_BRACE
| COMMA expression concatenation_cont
;

multiple_concatenation :
  OPEN_SQ_BRACE constant_expression concatenation CLOSE_SQ_BRACE
| OPEN_SQ_BRACE constant_expression concatenation_cont
;

constant_multiple_concatenation : 
  OPEN_SQ_BRACE constant_expression constant_concatenation CLOSE_SQ_BRACE
| OPEN_SQ_BRACE constant_expression constant_concatenation_cont
;

module_path_concatenation : 
  OPEN_SQ_BRACE module_path_expression modpath_concatenation_cont
;

modpath_concatenation_cont : 
  CLOSE_SQ_BRACE
| COMMA module_path_expression modpath_concatenation_cont
;

module_path_multiple_concatenation : 
  OPEN_SQ_BRACE constant_expression module_path_concatenation CLOSE_SQ_BRACE
;

net_concatenation :
  OPEN_SQ_BRACE net_concatenation_value net_concatenation_cont
;

net_concatenation_cont :
  CLOSE_SQ_BRACE
| COMMA net_concatenation_value net_concatenation_cont
;

sq_bracket_expressions :
  OPEN_SQ_BRACKET expression CLOSE_SQ_BRACKET
| OPEN_SQ_BRACKET range_expression CLOSE_SQ_BRACKET
| OPEN_SQ_BRACKET expression CLOSE_SQ_BRACKET sq_bracket_expressions
;

net_concatenation_value :
  hierarchical_net_identifier
| hierarchical_net_identifier sq_bracket_expressions
| hierarchical_net_identifier sq_bracket_expressions range_expression
| hierarchical_net_identifier range_expression
| net_concatenation
;

variable_concatenation :
  OPEN_SQ_BRACE variable_concatenation_value variable_concatenation_cont
;

variable_concatenation_cont :
  CLOSE_SQ_BRACE
| COMMA variable_concatenation_value variable_concatenation_cont
;

variable_concatenation_value :
  hierarchical_variable_identifier
| hierarchical_variable_identifier sq_bracket_expressions
| hierarchical_variable_identifier sq_bracket_expressions range_expression
| hierarchical_variable_identifier range_expression
| variable_concatenation
;


/* A.8.2 Function calls */

constant_expressions :
  constant_expression
| constant_expressions COMMA constant_expression
;

expressions :
  expression 
| expressions COMMA expression
;

constant_function_call :
  function_identifier attribute_instances OPEN_BRACKET constant_expressions 
  CLOSE_BRACKET
;

constant_function_call_pid :
  attribute_instances OPEN_BRACKET constant_expressions CLOSE_BRACKET
;

function_call : hierarchical_function_identifier
 attribute_instances OPEN_BRACKET expressions CLOSE_BRACKET
;

system_function_call : 
  system_function_identifier
| system_function_identifier OPEN_BRACKET CLOSE_BRACKET
| system_function_identifier OPEN_BRACKET expressions CLOSE_BRACKET
;


/* A.8.3 Expressions */

conditional_expression : 
  expression TERNARY attribute_instances expression COLON expression
;

constant_expression:
  constant_primary
| unary_operator attribute_instances constant_primary
| constant_expression PLUS  attribute_instances constant_expression
| constant_expression MINUS attribute_instances constant_expression
| constant_expression STAR  attribute_instances constant_expression
| constant_expression DIV   attribute_instances constant_expression
| constant_expression MOD   attribute_instances constant_expression
| constant_expression L_EQ  attribute_instances constant_expression
| constant_expression L_NEQ attribute_instances constant_expression
| constant_expression C_EQ  attribute_instances constant_expression
| constant_expression C_NEQ attribute_instances constant_expression
| constant_expression L_AND attribute_instances constant_expression
| constant_expression L_OR  attribute_instances constant_expression
| constant_expression POW   attribute_instances constant_expression
| constant_expression LT    attribute_instances constant_expression
| constant_expression LTE   attribute_instances constant_expression
| constant_expression GT    attribute_instances constant_expression
| constant_expression GTE   attribute_instances constant_expression
| constant_expression B_AND attribute_instances constant_expression
| constant_expression B_OR  attribute_instances constant_expression
| constant_expression B_XOR attribute_instances constant_expression
| constant_expression B_EQU attribute_instances constant_expression
| constant_expression LSR   attribute_instances constant_expression
| constant_expression LSL   attribute_instances constant_expression
| constant_expression ASR   attribute_instances constant_expression
| constant_expression ASL   attribute_instances constant_expression
| constant_expression TERNARY attribute_instances constant_expression COLON
  constant_expression
| string
;

constant_mintypmax_expression :
  constant_expression
| constant_expression COLON constant_expression COLON constant_expression
;

constant_range_expression :
  constant_expression
| constant_expression COLON       constant_expression
| constant_expression IDX_PRT_SEL constant_expression
;

expression :
  primary
| unary_operator attribute_instances primary %prec UNARY_OP
| expression PLUS  attribute_instances expression
| expression MINUS attribute_instances expression
| expression STAR  attribute_instances expression
| expression DIV   attribute_instances expression
| expression MOD   attribute_instances expression
| expression L_EQ  attribute_instances expression
| expression L_NEQ attribute_instances expression
| expression C_EQ  attribute_instances expression
| expression C_NEQ attribute_instances expression
| expression L_AND attribute_instances expression
| expression L_OR  attribute_instances expression
| expression POW   attribute_instances expression
| expression LT    attribute_instances expression
| expression LTE   attribute_instances expression
| expression GT    attribute_instances expression
| expression GTE   attribute_instances expression
| expression B_AND attribute_instances expression
| expression B_OR  attribute_instances expression
| expression B_XOR attribute_instances expression
| expression B_EQU attribute_instances expression
| expression LSR   attribute_instances expression
| expression LSL   attribute_instances expression
| expression ASR   attribute_instances expression
| expression ASL   attribute_instances expression
| conditional_expression
| string
;

mintypmax_expression :
  expression
| expression COLON expression COLON expression
;

module_path_conditional_expression :
  module_path_expression TERNARY attribute_instances module_path_expression
  COLON module_path_expression
;

module_path_expression :
  module_path_primary
| unary_module_path_operator attribute_instances module_path_primary
| module_path_expression binary_module_path_operator attribute_instances
  module_path_expression
| module_path_conditional_expression
;

module_path_mintypemax_expression :
  module_path_expression
| module_path_expression COLON module_path_expression COLON 
  module_path_expression
;

range_expression :
  expression
| expression COLON       constant_expression
| expression IDX_PRT_SEL constant_expression %prec IDX_PRT_SEL
;

/* A.8.4 Primaries */

constant_primary :
  constant_concatenation {
      $$ = ast_new_constant_primary(PRIMARY_CONCATENATION);
      $$ -> value.concatenation = $1;
}
| constant_function_call{
      $$ = ast_new_constant_primary(PRIMARY_FUNCTION_CALL);
      $$ -> value.function_call = $1;
}
| OPEN_BRACKET constant_mintypmax_expression CLOSE_BRACKET{
      $$ = ast_new_constant_primary(PRIMARY_MINMAX_EXP);
      $$ -> value.minmax = $2;
}
| constant_multiple_concatenation{
      $$ = ast_new_constant_primary(PRIMARY_CONCATENATION);
      $$ -> value.concatenation = $1;
}
| genvar_identifier{
      $$ = ast_new_constant_primary(PRIMARY_IDENTIFIER);
      $$ -> value.identifier = $1;
}
| number{
      $$ = ast_new_constant_primary(PRIMARY_NUMBER);
      $$ -> value.number = $1;
}
| parameter_identifier{
      $$ = ast_new_constant_primary(PRIMARY_IDENTIFIER);
      $$ -> value.identifier = $1;
}
| specparam_identifier{
      $$ = ast_new_constant_primary(PRIMARY_IDENTIFIER);
      $$ -> value.identifier = $1;
}
| text_macro_usage{
      $$ = ast_new_constant_primary(PRIMARY_MACRO_USAGE);
      $$ -> value.identifier = $1;
}
;

primary :
  number{
      $$ = ast_new_primary(PRIMARY_NUMBER);
      $$ -> value.number = $1;
  }
| hierarchical_identifier sq_bracket_expressions{
      $$ = ast_new_primary(PRIMARY_NUMBER);
      $$ -> value.identifier = $1;
  }
| hierarchical_identifier sq_bracket_expressions OPEN_SQ_BRACKET
  range_expression CLOSE_SQ_BRACKET{
      $$ = ast_new_primary(PRIMARY_IDENTIFIER);
      $$ -> value.identifier = $1;
  }
| concatenation{
      $$ = ast_new_primary(PRIMARY_CONCATENATION);
      $$ -> value.concatenation = $1;
  }
| multiple_concatenation{
      $$ = ast_new_primary(PRIMARY_CONCATENATION);
      $$ -> value.concatenation = $1;
  }
| function_call{
      $$ = ast_new_primary(PRIMARY_FUNCTION_CALL);
      $$ -> value.function_call = $1;
  }
| system_function_call{
      $$ = ast_new_primary(PRIMARY_SYSTEM_CALL);
      $$ -> value.system_call = $1;
  }
| hierarchical_identifier constant_function_call_pid{
      $$ = ast_new_primary(PRIMARY_IDENTIFIER);
      $$ -> value.identifier = $1;
  }
| hierarchical_identifier{
      $$ = ast_new_primary(PRIMARY_IDENTIFIER);
      $$ -> value.identifier = $1;
  }
| OPEN_BRACKET mintypmax_expression CLOSE_BRACKET{
      $$ = ast_new_primary(PRIMARY_MINMAX_EXP);
      $$ -> value.minmax = $2;
  }
| text_macro_usage{
      $$ = ast_new_primary(PRIMARY_MACRO_USAGE);
      $$ -> value.macro = $1;
  }
;

module_path_primary :
  number{
      $$ = ast_new_module_path_primary(PRIMARY_NUMBER);
      $$ -> value.number = $1;
  }

| identifier{
      $$ = ast_new_module_path_primary(PRIMARY_IDENTIFIER);
      $$ -> value.identifier= $1;
  }

| module_path_concatenation{
      $$ = ast_new_module_path_primary(PRIMARY_CONCATENATION);
      $$ -> value.concatenation = $1;
  }

| module_path_multiple_concatenation{
      $$ = ast_new_module_path_primary(PRIMARY_CONCATENATION);
      $$ -> value.concatenation = $1;
  }

| function_call{
      $$ = ast_new_module_path_primary(PRIMARY_FUNCTION_CALL);
      $$ -> value.function_call = $1;
  }
| system_function_call{
      $$ = ast_new_module_path_primary(PRIMARY_SYSTEM_CALL);
      $$ -> value.system_call = $1;
  }
| constant_function_call{
      $$ = ast_new_module_path_primary(PRIMARY_FUNCTION_CALL);
      $$ -> value.function_call = $1;
  }
| OPEN_BRACKET module_path_mintypemax_expression CLOSE_BRACKET{
      $$ = ast_new_module_path_primary(PRIMARY_MINMAX_EXP);
      $$ -> value.minmax = $2;
  }
| text_macro_usage{
      $$ = ast_new_module_path_primary(PRIMARY_MACRO_USAGE);
      $$ -> value.macro = $1;
  }
;

/* A.8.5 Expression left-side values */

sq_bracket_constant_expressions :
  OPEN_SQ_BRACKET constant_expression CLOSE_SQ_BRACKET
| OPEN_SQ_BRACKET constant_expression CLOSE_SQ_BRACKET 
  sq_bracket_constant_expressions
;

net_lvalue :
  hierarchical_net_identifier{
    $$ = ast_new_lvalue_id(NET_IDENTIFIER, $1);
  }
| hierarchical_net_identifier sq_bracket_constant_expressions{
    $$ = ast_new_lvalue_id(NET_IDENTIFIER, $1);
  }
| hierarchical_net_identifier sq_bracket_constant_expressions 
  OPEN_SQ_BRACKET constant_range_expression CLOSE_SQ_BRACKET{
    $$ = ast_new_lvalue_id(NET_IDENTIFIER, $1);
  }
| hierarchical_net_identifier OPEN_SQ_BRACKET constant_range_expression 
  CLOSE_SQ_BRACKET{
    $$ = ast_new_lvalue_id(NET_IDENTIFIER, $1);
  }
| net_concatenation {
    $$ = ast_new_lvalue_concat(NET_CONCATENATION, $1);
  }
;

variable_lvalue :
  hierarchical_variable_identifier{
    $$ = ast_new_lvalue_id(VAR_IDENTIFIER, $1);
  }
| hierarchical_variable_identifier sq_bracket_constant_expressions{
    $$ = ast_new_lvalue_id(VAR_IDENTIFIER, $1);
  }
| hierarchical_variable_identifier sq_bracket_constant_expressions 
  OPEN_SQ_BRACKET constant_range_expression CLOSE_SQ_BRACKET{
    $$ = ast_new_lvalue_id(VAR_IDENTIFIER, $1);
  }
| hierarchical_variable_identifier OPEN_SQ_BRACKET constant_range_expression 
  CLOSE_SQ_BRACKET{
    $$ = ast_new_lvalue_id(VAR_IDENTIFIER, $1);
  }
| variable_concatenation{
    $$ = ast_new_lvalue_concat(VAR_CONCATENATION, $1);
  }

;

/* A.8.6 Operators */

unary_operator : PLUS    {$$ = $1;}
               | MINUS   {$$ = $1;}
               | L_NEG   {$$ = $1;}
               | B_NEG   {$$ = $1;}
               | B_AND   {$$ = $1;}
               | B_NAND  {$$ = $1;}
               | B_OR    {$$ = $1;}
               | B_NOR   {$$ = $1;}
               | B_XOR   {$$ = $1;}
               | B_EQU   {$$ = $1;}
               ;


unary_module_path_operator  : L_NEG  {$$=$1;}
                            | B_NEG  {$$=$1;}
                            | B_AND  {$$=$1;}
                            | B_NAND {$$=$1;}
                            | B_OR   {$$=$1;}
                            | B_NOR  {$$=$1;}
                            | B_XOR  {$$=$1;}
                            | B_EQU  {$$=$1;}
                            ;

binary_module_path_operator : L_EQ   {$$=$1;}
                            | L_NEQ  {$$=$1;}
                            | L_AND  {$$=$1;}
                            | L_OR   {$$=$1;}
                            | B_AND  {$$=$1;}
                            | B_OR   {$$=$1;}                    
                            | B_XOR  {$$=$1;}                    
                            | B_EQU  {$$=$1;}
                            ;

/* A.8.7 Numbers */

unsigned_number : UNSIGNED_NUMBER
                ;

number : NUMBER
       | unsigned_number
       ;

/* A.8.8 Strings */

string : STRING;

/* A.9.1 Attributes */

attribute_instances : {$$=NULL;}
                    | list_of_attribute_instances {$$=$1;}
                    ;

list_of_attribute_instances : 
  ATTRIBUTE_START attr_specs ATTRIBUTE_END {
      $$ = ast_new_attribute_node($2);
  }
| attribute_instances ATTRIBUTE_START attr_specs ATTRIBUTE_END{
    if($1 != NULL){
        ast_append_attribute($1 -> value.attributes, $3);
        $$ = $1;
    } else {
        $$ = ast_new_attribute_node($3);
    }
  }
                            ;

attr_specs : {$$ = NULL;}
           | attr_spec {
               $$ = $1;
           }
           | attr_specs COMMA attr_spec {
               // Append the new item to the existing list and return.
               ast_append_attribute($1,$3);
               $$ = $1;
           }
           ;

attr_spec : attr_name EQ constant_expression
                {$$ = ast_new_attributes($1,$3);}
          | attr_name 
                {$$ = ast_new_attributes($1, NULL);}
          ;

attr_name : identifier {$$=$1;};

/* A.9.2 Comments */

comment             : one_line_comment {$$=$1;}
                    | block_comment    {$$=$1;}
                    ;

one_line_comment    : COMMENT_LINE {$$=$1;};

block_comment       : COMMENT_BLOCK {$$=$1;};

/* A.9.3 Identifiers */

arrayed_identifier              : simple_arrayed_identifier     {$$=$1;}
                                | escaped_arrayed_identifier    {$$=$1;}
                                ;

block_identifier                : identifier {$$=$1;};
cell_identifier                 : identifier {$$=$1;};
config_identifier               : identifier {$$=$1;};
escaped_arrayed_identifier      : escaped_identifier range_o;
escaped_hierarchical_identifier : escaped_hierarchical_branch 
                                  escaped_hierarchical_identifiers
                                ;

escaped_hierarchical_identifiers: DOT simple_hierarchical_identifier
                                | DOT escaped_hierarchical_identifier
                                | escaped_hierarchical_identifiers
                                  DOT simple_hierarchical_identifier
                                | escaped_hierarchical_identifier DOT
                                  escaped_hierarchical_identifiers
                                ;


escaped_identifier              : '\''
                                  anys 
                                  white_space {$$=$<identifier>2;}
                                ;

anys : anys ANY {$$=$2;}
     | ANY {$$ = $1;}
     ;

event_identifier                : identifier {$$=$1;};
function_identifier             : identifier {$$=$1;};
gate_instance_identifier        : arrayed_identifier{$$=$1;};
generate_block_identifier       : identifier {$$=$1;};
genvar_identifier               : identifier {$$=$1;};
hierarchical_block_identifier   : hierarchical_identifier{$$=$1;};
hierarchical_event_identifier   : hierarchical_identifier{$$=$1;};
hierarchical_function_identifier: hierarchical_identifier{$$=$1;};
hierarchical_identifier         : simple_hierarchical_identifier {$$=$1;}
                                | escaped_hierarchical_identifier{$$=$1;}
                                ;

hierarchical_net_identifier     : hierarchical_identifier{$$=$1;};
hierarchical_variable_identifier: hierarchical_identifier{$$=$1;};
hierarchical_task_identifier    : hierarchical_identifier{$$=$1;};
identifier                      : simple_identifier  {$$=$1;}
                                | escaped_identifier {$$=$1;}
                                | text_macro_usage {$$=$1;}
                                ;

inout_port_identifier           : identifier {$$=$1;};
input_port_identifier           : identifier {$$=$1;};
instance_identifier             : identifier {$$=$1;};
library_identifier              : identifier {$$=$1;};
module_identifier               : identifier {$$=$1;};
module_instance_identifier      : arrayed_identifier;
net_identifier                  : identifier {$$=$1;};
output_port_identifier          : identifier {$$=$1;};
parameter_identifier            : identifier  {$$=$1;}
                                | hierarchical_identifier{$$=$1;}
                                ;
port_identifier                 : identifier {$$=$1;};
real_identifier                 : identifier {$$=$1;};
simple_arrayed_identifier       : simple_identifier range_o ;

simple_hierarchical_identifier  : simple_hierarchical_branch {$$=$1;}
                                | simple_hierarchical_branch DOT
                                  escaped_identifier {$$=$1;}
                                ;

simple_identifier               : SIMPLE_ID {$$=$1;}
                                | text_macro_usage {$$=$1;}
                                ;

specparam_identifier            : identifier {$$=$1;};

system_function_identifier      : SYSTEM_ID {$$=$1;};
system_task_identifier          : SYSTEM_ID {$$=$1;};

task_identifier                 : identifier {$$=$1;};
topmodule_identifier            : identifier {$$=$1;};
udp_identifier                  : identifier {$$=$1;};
udp_instance_identifier         : arrayed_identifier{$$=$1;};
variable_identifier             : identifier {$$=$1;};

/* A.9.4 Identifier Branches */

/* Semantic checking needed to make sure that the "expression"
in the closed brackets reduces to an "unsigned_number" */

simple_hierarchical_branch : 
  SIMPLE_ID {$$=$1;}
| SIMPLE_ID OPEN_SQ_BRACKET expression CLOSE_SQ_BRACKET {$$=$1;}
| SIMPLE_ID OPEN_SQ_BRACKET range_expression CLOSE_SQ_BRACKET {$$=$1;}
| simple_hierarchical_branch DOT simple_identifier{$$=$1;}
| simple_hierarchical_branch DOT SIMPLE_ID OPEN_SQ_BRACKET
expression CLOSE_SQ_BRACKET {$$=$1;}
| simple_hierarchical_branch DOT SIMPLE_ID OPEN_SQ_BRACKET
range_expression CLOSE_SQ_BRACKET {$$=$1;}
;


/* Semantic checking needed to make sure that the "expression"
in the closed brackets reduces to an "unsigned_number" */

escaped_hierarchical_branch :
  escaped_hierarchical_branch DOT escaped_identifier {$$=$1;}
| escaped_hierarchical_branch DOT escaped_identifier OPEN_SQ_BRACKET 
  expression CLOSE_SQ_BRACKET {$$=$1;}
| escaped_identifier{$$=$1;}
| escaped_identifier OPEN_SQ_BRACKET expression CLOSE_SQ_BRACKET{$$=$1;}
| escaped_identifier OPEN_SQ_BRACKET range_expression CLOSE_SQ_BRACKET
{$$=$1;}
;

white_space : SPACE | TAB | NEWLINE;

%%
