
##------------------------------------------------------------------------
## Compiler Tools & Flags
##------------------------------------------------------------------------

OBJ_DIR         = ./obj
LIB_DIR         = ./lib
BIN_DIR         = ./bin
GEN_DIR         = ./gen

SRC_DIR         = ../src

CC              = gcc
CC_FLAGS        = -Wall -I$(SRC_DIR) -I$(GEN_DIR)

AR              = ar
AR_FLAGS        = rcs

##------------------------------------------------------------------------
## Auxiliary Rules and Actions
##------------------------------------------------------------------------

all: parser-app parser-lib

clean:
	rm -f $(OBJ_DIR)/*
	rm -f $(LIB_DIR)/*
	rm -f $(BIN_DIR)/*
	rm -f $(GEN_DIR)/*

fromclean: clean all

##------------------------------------------------------------------------
## BISON & FLEX Source, Output and Options
##------------------------------------------------------------------------

FLEX_IN         = $(SRC_DIR)/verilog_scanner.l
FLEX_OUT        = $(GEN_DIR)/verilog_scanner.c

BISON_IN        = $(SRC_DIR)/verilog_parser.y
BISON_OUT       = $(GEN_DIR)/verilog_parser.tab.c

FLEX_OPTS       = --yylineno
BISON_OPTS      = 

$(GEN_DIR)/%.c : $(SRC_DIR)/%.l
	flex $(FLEX_OPTS) -o $(FLEX_OUT) $(FLEX_IN)

$(GEN_DIR)/%.tab.c : $(SRC_DIR)/%.y
	bison $(BISON_OPTS) -o $(BISON_OUT) $(BISON_IN)

##------------------------------------------------------------------------
## C Source and Object Code
##------------------------------------------------------------------------

LIB_NAME        = verilogparser
LIB_FILE        = $(LIB_DIR)/lib$(LIB_NAME).a

APP_NAME        = verilog-app
APP_OUT         = $(BIN_DIR)/$(APP_NAME)

APP_OBJ         = $(OBJ_DIR)/main.o

SRC_OBJS        = $(OBJ_DIR)/verilog_ast.o          \
                  $(OBJ_DIR)/verilog_ast_common.o   \
                  $(OBJ_DIR)/verilog_parser.o

GEN_OBJS        = $(OBJ_DIR)/verilog_scanner.o  \
                  $(OBJ_DIR)/verilog_parser.tab.o


parser-lib : $(FLEX_OUT) $(BISON_OUT) $(SRC_OBJS) $(GEN_OBJS)
	$(AR) $(AR_FLAGS) $(LIB_FILE) $(SRC_OBJS) $(GEN_OBJS)

parser-app : parser-lib $(APP_OBJ)
	$(CC) $(CC_FLAGS) \
          -static $(APP_OBJ) \
          -L$(LIB_DIR) \
          -l$(LIB_NAME) \
          -o $(APP_OUT)

# Rule for human written source files.
$(OBJ_DIR)/%.o : $(SRC_DIR)/%.c
	$(CC) $(CC_FLAGS) -o $@ -c $< 

# Rule for generated source files.
$(OBJ_DIR)/%.o : $(GEN_DIR)/%.c
	$(CC) $(CC_FLAGS) -o $@ -c $< 
