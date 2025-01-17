#!/bin/bash

lang="
    go
    rust
    c
    cpp
    python
    javascript
    other
"

utils="
   cd 
"

type=`printf "languages\nutils" | fzf --reverse`
echo type: $type

case $type in
    languages)
        selected=`echo $lang | tr ' ' '\n' | fzf --reverse`
        case $selected in
            other)
                read -p "Your language?: " selected
                ;;
            *)
                ;;
        esac
        echo chosen: $selected

        read -p "query: " query
        query=`echo $query | tr ' ' '+'`

        curl cht.sh/$selected/$query | bat --paging=always
        ;;

    utils)
        selected=`echo $utils | tr ' ' '\n' | fzf --reverse`
        ;;

    *)
        exit
        ;;
esac
