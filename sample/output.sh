#!/bin/sh

#bench "echo"
@begin
echo "test"
@end

#bench "printf"
@begin
printf "test\n"
@end

#bench "print" only=ksh,mksh,lksh,pdksh,zsh
@begin
print "test"
@end
