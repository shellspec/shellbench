#!/bin/sh

#bench "positional params"
func() {
  @begin
  set -- "1"
  @end
}
func

#bench "variable"
func() {
  @begin
  var=1
  @end
}
func

#bench "local var" skip=ksh,yash
func() {
  local var
  @begin
  var=1
  @end
}
func

#bench "local var (typeset)" only=ksh,yash
function func {
  typeset var
  @begin
  var=1
  @end
}
func
