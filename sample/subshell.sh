#!/bin/sh

#bench "no subshell"
@begin
true
@end

#bench "brace"
@begin
{
    true
}
@end

#bench "subshell"
@begin
(
    true
)
@end

#bench "command subs"
@begin
var=$(true)
@end

#bench "external command"
@begin
/usr/bin/true
@end
