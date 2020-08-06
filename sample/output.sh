#!/bin/sh

#bench "echo"
@begin
echo "test"
@end

#bench "printf"
@begin
printf "test\n"
@end

#bench "print"
@begin
print "test"
@end
