#!/bin/sh

setup() {
  unset no_such_variable
}

@bench blank only=mksh,lksh,zsh
# comment only

@bench "assign variable"
var=

@bench "define function"
foo() { :; }

@bench "undefined variable"
${no_such_variable:-}

@bench ": command"
:
