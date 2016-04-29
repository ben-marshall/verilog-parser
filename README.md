
# Verilog Parser

This repository contains a flex / bison parser for the IEEE 1364-2001 Verilog
Standandard.

**Notes to self:**
- Need to add some state to the lexer so it knows when to return an identifier
  and not a hex digit / number base. Can be done by entering new state when a
  net type is encountered (during a declaration) then returning to the initial
  state when we see a semicolon, ending the declaration.
