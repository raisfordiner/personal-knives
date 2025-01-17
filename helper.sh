#!/bin/bash

method="
    cht.sh
    man
    tldr
"

selected=`echo $method | tr ' ' '\n' | fzf --reverse`
echo method: $selected

query=""

case $selected in
    "man")
        read -p "query: " query
        man $query | bat --paging=always
        ;;
    "tldr")
        read -p "query: " query
        tldr $query | bat --paging=always
        ;;
    "cht.sh")
        ~/ShellScripts/cht.sh
        ;;
    *)
        echo What da hell man!?
        ;;
esac
