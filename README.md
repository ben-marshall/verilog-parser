
# Verilog Parser

![Build Status](https://travis-ci.org/ben-marshall/verilog-parser.svg?branch=master) [Build & CI Information](https://travis-ci.org/ben-marshall/verilog-parser)

This repository contains a flex / bison parser for the IEEE 1364-2001 Verilog
Standandard.

## Getting Started

This will get you going.

    ```sh
    $> source bin/project.sh
    $> cd build
    $> make docs
    $> make
    $> make test
    ```

The `project.sh` script will also call the script which downloads the tests
from asic-world.com. The project uses CMake as it's build system, and
CTest for running the various test programs.

## Testing

The test suite is comprised of example code taken from
the fantastic [ASIC World](http://www.asic-world.com/) tutorial on Verilog.
The idea being that by using a well-known and comprehensive set of
tutorial examples, almost all of the syntactic features of the language can be
hit very easily with little effort.

## Contributing

Ofcourse, the current test suite does not test **everything** and I expect
there to be awkward bugs. This is the first time I have written a parser of
this size and complexity.

If you find a bug, or otherwise want to contribute, then please don't
hesitate to file a pull request. If you have found a bug, please add a test
for the bug in the `tests/` folder. This should trigger the bug in the orignal
code, and ideally, not trigger in you're submitted fix! I'm open to people
just submitting bugs as well, but it might take longer for me to get round to
fixing it!

## Todo list

There are some things that the parser does not support:

- SystemVerilog. Sorry folks, its another language completely. This parser
  should serve as a very good starting point if you want to build one though,
  since Verilog is a subset of SystemVerilog.
- System timing checks. See Annex 7.5.1 of the specification for what this
  omits. It hopefully won't be long before I get round to adding it though.
- Abstract Syntax Trees. This is a work in progress, but it will be in there
  eventually.
