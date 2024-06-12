#!/bin/sh

setup() { string='string'; }

#bench "string length"
@begin
var=${#string}
@end
