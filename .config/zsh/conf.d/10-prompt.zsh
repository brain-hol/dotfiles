autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats '%b%u%c'
zstyle ':vcs_info:git:*' actionformats '%b%u%c %a'

_vcs_info_wrapper() {
    vcs_info
    if [[ -n "${vcs_info_msg_0_}" ]]; then
        echo " | %F{green}${vcs_info_msg_0_}%f"
    fi
}

EXTRA_LINE=0
precmd() {
    if [[ "$EXTRA_LINE" == "0" ]]; then
        EXTRA_LINE=1
    else
        print ""
    fi
}

preexec() {
    if [[ "$2" == ("clear"|"clear -x"|"reset") ]]; then
        EXTRA_LINE=0
    fi
}

PATH_SECTION='%F{blue}%3d%f'
ERROR_SECTION='%(?.. | %F{red}%?%f)'

PS1="%B[ ${PATH_SECTION}\$(_vcs_info_wrapper)${ERROR_SECTION} ]
>%b "


