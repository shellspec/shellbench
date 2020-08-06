#!/bin/sh

#bench "blank"
@begin
@end

#bench "assign variable"
@begin
var=
@end

#bench "define function"
@begin
foo() { :; }
@end

#bench "undefined variable"
unset no_such_variable
@begin
${no_such_variable:-}
@end

#bench ": command"
@begin
:
@end
