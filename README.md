
# Verilog Parser

[![Documentation](https://codedocs.xyz/ben-marshall/verilog-parser.svg)](https://codedocs.xyz/ben-marshall/verilog-parser/)
[![Build Status](https://travis-ci.org/ben-marshall/verilog-parser.svg?branch=master)](https://travis-ci.org/ben-marshall/verilog-parser/branches)
[![Coverage Status](https://coveralls.io/repos/github/ben-marshall/verilog-parser/badge.svg?branch=master)](https://coveralls.io/github/ben-marshall/verilog-parser?branch=master)
![Licence: MIT](https://img.shields.io/badge/License-MIT-blue.svg)

This repository contains a flex / bison parser for the IEEE 1364-2001 Verilog
Standard.

- [Getting Started](#getting-started)
- [Testing](#testing)
- [Contributing](#contributing)
- [Design Choices](#design-choices)
- [Todo List](#todo)
- [Tool Wishlist](#wishlist)

---

## Getting Started

This will get you going workspace wise.

    ```sh
    $> make all
    $> make test-all
    ```

This will download the test suite files, setup the build directory, and
compile the parser, library and test app.

To start using the parser in your own code, take a look at 
[main.c](./src/main.c) which is a simple demonstration app used for testing
and coverage. The basic code which you need is something like this:

```C
// Initialise the parser.
verilog_parser_init();

// Open A File handle to read data in.
FILE * fh = fopen("my_verilog_file.v", "r");

// Parse the file and store the result.
int result = verilog_parse_file(fh);

if(result == 0)
    printf("Parse successful\n");
else
    printf("Parse failed\n");

fclose(fh);
```

You can keep calling `verilog_parse_file(fh)` on as many different file
handles as you like to build up a multi-file project AST representation.
The parser will automatically follow any `include` directives it finds.

For an example of using the library in a real*ish* situation, the
[verilog-dot](https://github.com/ben-marshall/verilog-dot) project shows how
the library can be integrated into an existing project and used.

## Testing

The test suite is comprised of example code taken from
the fantastic [ASIC World](http://www.asic-world.com/) tutorial on Verilog.
The idea being that by using a well-known and comprehensive set of
tutorial examples, almost all of the syntactic features of the language can be
hit very easily with little effort.

The repository also contains an archive of verilog source code taken from the
[OpenSPARCT1](http://www.oracle.com/technetwork/systems/opensparc/opensparc-t1-page-1444609.html)
microprocessor from Oracle. This archive is unpacked into the `tests/`
directory when `make setup` is run, and ensures that the parser is able to
handle a *real-life* source base in terms of scale and complexity.  The full
workspace environment required to run or analyse the OpenSPARCT1 is not
provided, the files only demonstrate the ability to correctly parse a large
project, and handle the various internal header files and preprocessor
definitions.

## Contributing

Of-course, the current test suite does not test **everything** and I expect
there to be awkward bugs. This is the first time I have written a parser of
this size and complexity. I have set up automatic coverage collection after
each CI build, this gives a good indication of which parts of the code are
tested and dependable. Hitting 100% coverage for a parser is a *pain*, but
hopefully over time it will tend that way. The current situation is that
all of the verilog language features that are used commonly are tested for.
The main missing bits are due to a lack of test cases for user defined
primitives (UDPs).

If you find a bug, or otherwise want to contribute, then please don't
hesitate to file a pull request. If you have found a bug, please add a test
for the bug in the `tests/` folder. This should trigger the bug in the original
code, and ideally, not trigger in you're submitted fix! I'm open to people
just submitting bugs as well, but it might take longer for me to get round to
fixing it!

There is more information on how to help in the [contributing](CONTRIBUTING.md)
guide.

## Design Choices

### Why C, why not something more modern?

This comes down to who will use this tool, and who will develop this tool.
Ideally, these are the same people. The current demographic of people working
in ASIC / RTL design is that of (please excuse my generalising) electronic
engineers, with (again, sorry) little experience of recent programming language
technologies like Haskell (great for parsing and formal/state-based assertions)
and Python (perl is still king in ASIC design flows, but this is changing).
Further, the size and complexity of many RTL designs means you need a language
that has lots of low-level acceleration potential, as well as being
tried-and-tested. C meets most of these points, while also being something that
electronics engineers are more likely to be familiar with and comfortable using.

### Why flex/bison, why not Boost::Sprint, ANTLR, or something custom?

Similar to the above answer. These are tools that are *very* old, and *very*
stable. They are more likely to be available and supported for the kinds
of development environments RTL designers work in which are often at least
a decade old. What flex and bison loose in terms of nice features, syntactic
sugar, and, sadly, ease of use - they make up for in stability and
likelihood of familiarity for the people I hope will use this project.
Many of the design decisions around this project have been equal parts
social and engineering in their justification.

### Why not adapt an existing parser?

Good question. I looked at the parsers found in [Icarus
Verilog](http://iverilog.icarus.com/) and
[yosys](http://www.clifford.at/yosys/) but found that while they were
excellent in and of themselves, they were too well adapted to their end use to
be made into a general purpose parser. They did inform me well on how to parse
the trickier parts of the grammar though, and I certainly cannot fault them in
any other way! This parser has been written to correspond very closely to the
IEEE Verilog 2001 Syntax specification. This means it is longer (by line
count) but much easier to understand and relate to the original specification.
For example, each grammar rule in the [Bison file](./verilog_parser.y) matches
almost exactly with it's namesake in the IEEE spec.

---


## Todo

There are some things that the parser does not support:

- System-Verilog. Sorry folks, its another language completely. This parser
  should serve as a very good starting point if you want to build one though,
  since Verilog is a subset of System-Verilog.
- System timing checks. See Annex 7.5.1 of the specification for what this
  omits. It hopefully won't be long before I get round to adding it though.

## Wishlist

This is a wishlist of tools that I would like to use the parser in. If
anyone else would like to use the parser as the basis for their own tools
like this, I am more than happy to help!

- A code indenter / style format checker.
- A pre-processed source checker (expand macros and parameters, etc) for easy
  browsing of generic logic blocks and cores.
- Something to highlight when signals cross clock domains.
- Critical path identifier (something which doesn't take 20 minuets to run on 
  a grid engine) 
- A switching probability analysis tool. 
- This could even feed into a rough power & energy estimation tool. 
- A simple hierarchy visualiser, which you can feed all your project files into 
  and which will spit out a digested view of the module hierarchy. 
- Proper Doxygen support for Verilog, or failing that, a 
  [Doxygen like tool](https://github.com/ben-marshall/verilog-doc) for Verilog
