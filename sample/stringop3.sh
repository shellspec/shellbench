#!/bin/sh

setup() { string='abc:def:ghi'; }

#bench "str remove ^ shortest builtin"
@begin
var=${string#*:}
@end

#bench "str remove ^ shortest echo | cut"
@begin
var=$(echo "$string" | cut '-d:' -f2-)
@end

#bench "str remove ^ shortest cut here doc"
@begin
var=$(cut '-d:' -f2- << EOF
$string
EOF
)
@end

#bench "str remove ^ shortest cut here str"
@begin
var=$(cut '-d:' -f2- <<< "$string")
@end

#bench "str remove ^ longest builtin"
@begin
var=${string##*:}
@end

#bench "str remove ^ longest echo | cut"
@begin
var=$(echo "$string" | cut '-d:' -f3)
@end

#bench "str remove ^ longest cut here doc"
@begin
var=$(cut '-d:' -f3 << EOF
$string
EOF
)
@end

#bench "str remove ^ longest cut here str"
@begin
var=$(cut '-d:' -f3 <<< "$string")
@end

#bench "str remove $ shortest builtin"
@begin
var=${string%:*}
@end

#bench "str remove $ shortest echo | cut"
@begin
var=$(echo "$string" | cut '-d:' -f-2)
@end

#bench "str remove $ shortest cut here doc"
@begin
var=$(cut '-d:' -f-2 << EOF
$string
EOF
)
@end

#bench "str remove $ shortest cut here str"
@begin
var=$(cut '-d:' -f-2 <<< "$string")
@end

#bench "str remove $ longest builtin"
@begin
var=${string%%:*}
@end

#bench "str remove $ longest echo | cut"
@begin
var=$(echo "$string" | cut '-d:' -f1)
@end

#bench "str remove $ longest cut here doc"
@begin
var=$(cut '-d:' -f1 << EOF
$string
EOF
)
@end

#bench "str remove $ longest cut here str"
@begin
var=$(cut '-d:' -f1 <<< "$string")
@end
