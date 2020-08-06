#!/bin/sh

setup() { i=1; }
cleanup() { :; }

#bench "posix"
@begin
i=$((i+1))
@end

#bench "typeset -i"
typeset -i i
@begin
i=$((i+1))
@end

#bench "increment"
typeset -i i
@begin
((i++))
@end
