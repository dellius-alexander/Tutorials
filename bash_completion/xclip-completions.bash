#!/usr/bin/env bash
# xclip autocompletions
# See: man xclip
###########################################################
have xclip &&
_xclip_complete()
{
local cur prev

COMPREPLY=()
cur=${COMP_WORDS[COMP_CWORD]}
prev=${COMP_WORDS[COMP_CWORD-1]}

if [ $COMP_CWORD -eq 1 ]; then
COMPREPLY=( $(compgen -W "-i -in -o -out -f -filter -l -loop -t -target -d -display \
-h -help -selection -version -silent -quiet -verbose -noutf8" -- $cur) )
elif [ $COMP_CWORD -eq 2 ]; then
    case "$prev" in
        '-selection')
        COMPREPLY=( $(compgen -W "primary secondary clipboard" -- $cur) )
        ;;
        -d | -display)
        COMPREPLY=( $(compgen -W "$(hostname -I | awk '{print $1}')$DISPLAY" -- $cur) )
        ;;
        *)
        ;;
    esac
fi

return 0
} &&
complete -F _xclip_complete xclip
