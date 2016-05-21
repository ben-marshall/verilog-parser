
# Verilog Parser

[![Build Status](https://travis-ci.org/ben-marshall/verilog-parser.svg?branch=master)](https://travis-ci.org/ben-marshall/verilog-parser)

This repository contains a flex / bison parser for the IEEE 1364-2001 Verilog
Standandard. It currently passes 97% of all the test inputs, but struggles
with signal concatenations and range expressions.
