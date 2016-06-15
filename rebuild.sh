#!/bin/sh

ret=0

for src in creational/*.cr structural/*.cr behavioral/*.cr
do
  (set -x; crystal compile --no-codegen $src) || ret=$?
done

exit $ret
