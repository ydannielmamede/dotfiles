#!/bin/bash
# Unity chama: editor arquivo +linha
file="$1"
line="${2#+}"  # remove o "+" do argumento

exec kitty nvim +"$line" "$file"  # troque kitty pelo seu terminal
