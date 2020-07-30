#!/bin/sh

@bench "echo"
echo "test"

@bench "printf"
printf "test\n"

@bench "print" only=ksh,mksh,lksh,pdksh,zsh
print "test\n"
