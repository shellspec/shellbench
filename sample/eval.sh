#!/bin/sh

#bench "direct assign"
@begin
func() {
  var=1
}
func
@end

#bench "eval assign"
@begin
func() {
  eval "var=1"
}
func
@end

#bench "command subs"
@begin
func() {
  echo 1
}
var=$(func)
@end
