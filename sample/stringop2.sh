#!/bin/sh

setup() { string='string'; }

#bench "substr 1 builtin"
@begin
var=${string:2}
@end

#bench "substr 1 echo | cut"
@begin
var=$(echo "$string" | cut -c3-)
@end

#bench "substr 1 cut here doc"
@begin
var=$(cut -c3- << EOF
$string
EOF
)
@end

#bench "substr 1 cut here str"
@begin
var=$(cut -c3- <<< "$string")
@end

#bench "substr 2 builtin"
@begin
var=${string:2:3}
@end

#bench "substr 2 echo | cut"
@begin
var=$(echo "$string" | cut -c3-5)
@end

#bench "substr 2 cut here doc"
@begin
var=$(cut -c3-5 << EOF
$string
EOF
)
@end

#bench "substr 2 cut here str"
@begin
var=$(cut -c3-5 <<< "$string")
@end

#bench "substr 2 expr"
@begin
var=$(expr substr $string 3 3)
@end
