#!/bin/sh

setup() { string='abc:def:ghi'; }

#bench "str subst one builtin"
@begin
var=${string/:/|}
@end

#bench "str subst one echo | sed"
@begin
var=$(echo "$string" | sed -e 's/:/|/')
@end

#bench "str subst one sed here doc"
@begin
var=$(sed -e 's/:/|/' << EOF
$string
EOF
)
@end

#bench "str subst one sed here str"
@begin
var=$(sed -e 's/:/|/' <<< "$string")
@end

#bench "str subst all builtin"
@begin
var=${string//:/|}
@end

#bench "str subst all echo | sed"
@begin
var=$(echo "$string" | sed -e 's/:/|/g')
@end

#bench "str subst all sed here doc"
@begin
var=$(sed -e 's/:/|/g' << EOF
$string
EOF
)
@end

#bench "str subst all sed here str"
@begin
var=$(sed -e 's/:/|/g' <<< "$string")
@end

#bench "str subst front builtin"
@begin
var=${string/#abc:/cba:}
@end

#bench "str subst front echo | sed"
@begin
var=$(echo "$string" | sed -e 's/^abc:/cba:/')
@end

#bench "str subst front here doc"
@begin
var=$(sed -e 's/^abc:/cba:/' << EOF
$string
EOF
)
@end

#bench "str subst front sed here str"
@begin
var=$(sed -e 's/^abc:/cba:/' <<< "$string")
@end

#bench "str subst back builtin"
@begin
var=${string/%:ghi/:ihg}
@end

#bench "str subst back echo | sed"
@begin
var=$(echo "$string" | sed -e 's/:ghi$/:ihg/g')
@end

#bench "str subst back here doc"
@begin
var=$(sed -e 's/:ghi$/:ihg/g' << EOF
$string
EOF
)
@end

#bench "str subst back sed here str"
@begin
var=$(sed -e 's/:ghi$/:ihg/g' <<< "$string")
@end
