#!/bin/sh

#bench "no func"
@begin
:
@end

#bench "func"
func() {
  :
}
@begin
func
@end
