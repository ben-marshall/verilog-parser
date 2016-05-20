
# Verilog Parser

[![Build Status](https://travis-ci.org/ben-marshall/verilog-parser.svg?branch=master)](https://travis-ci.org/ben-marshall/verilog-parser)

This repository contains a flex / bison parser for the IEEE 1364-2001 Verilog
Standandard.

## Bison Grammar

The non-terminal suffix conventions are:
- `*_s` denotes a sequence. That is, one or more members.
- `*_o` denotes an optional member. It evaluates to one, or zero members.
- `*_os` denotes an optional sequence. It evaluates to zero or more members.

**Notes to self:**
- Use the following search term on Google to get a load of example tests:
  `"endmodule" site:http://www.asic-world.com/code/verilog_tutorial/`
