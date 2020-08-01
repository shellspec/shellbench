#!/bin/sh

setup() { i=1; }
cleanup() { :; }

#bench "posix"
@begin
i=$((i+1))
@end

#bench "typeset -i" only=bash,ksh,mksh,zsh
typeset -i i
@begin
#i=$((i+1))
@end

#bench "increment" only=bash,ksh,mksh,zsh
typeset -i i
@begin
#((i++))
@end
