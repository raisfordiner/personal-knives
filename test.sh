#!/bin/sh

list="
    one
    two
    three
    four
    five
"

#list2=($(echo $list | tr ' ' '\n'))

#list2=`echo $list | tr ' ' '\n' | fzf --reverse --bind x:select,z:deselect,enter:accept-non-empty -m`

select obj in $(echo $list)
do
    echo $obj
done
