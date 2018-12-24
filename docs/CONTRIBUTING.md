
# Contributing

This document contains some useful tips on how to help contribute to this
repository.

---

## Useful Stuff

- [Documentation](https://codedocs.xyz/ben-marshall/verilog-parser/) is hosted
  on codedocs.xyz. This is generated automatically with every commit to master
  from the internal documentation in `doc/` and throughout the code in `src/`
- [Flex](http://flex.sourceforge.net/manual/) Lexical Analyser Manual.
- [Bison](http://dinosaur.compilertools.net/bison/index.html) Parser
  generator manual.

## Submitting Bugs

You can use the issue template to submit bugs. This includes:

- A description of where in the program the bug occurs (if known)
- Sample input which triggers the bug. This can also be submitted in a
  pull request.
- A clear description of what *should* happen and what *actually* happens.
- In the case of a segmentation fault, a debug trace from valgrind is also
  very useful, along with the build log.

## Fixing Bugs

If you find a bug and want to fix it yourself, thats super! You can use
the pull request template:

- Always describe clearly the bug you are fixing, it is worth raising an
  issue even if you are fixing it straight away. This means there will be a
  record of the bug.
- Always add a test in `tests/` which triggers the bug prior to your fix,
  and which passes after your fix.

## New Features

Raise these as an issue and tag them as a feature request. They can then be
discussed in depth in terms of feasability and appropriateness.

