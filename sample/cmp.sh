#!/bin/sh

setup() { string=""; }

#bench "[ ]"
@begin
if [ "$string" = "string" ]; then
  :
fi
@end

#bench "[[ ]]" skip=sh,dash,yash,posh
@begin
if [[ $string == "string" ]]; then
  :
fi
@end

#bench "case"
@begin
case $string in (string)
  :
esac
@end
