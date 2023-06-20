################################################################################
# History
################################################################################
setopt SHARE_HISTORY
HISTFILE="$XDG_STATE_HOME/zsh_history"
HISTSIZE=1000000 # In memory
SAVEHIST=1000000 # In file


################################################################################
# Prompt
################################################################################
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


################################################################################
# Util Functions
################################################################################
function _bh_printerr() {
    local error_message="$1"
    local error_reason="$2"

    local prefix="[ERROR]"
    [[ -n "$error_reason" ]] && error_reason=": $error_reason"
    printf '%s %s%s.\n' "$prefix" "$error_message" "$error_reason"
}

function _bh_is_valid_file() {
    local file_path="$1"
    local error_message="\"$file_path\" cannot be referenced"

    if [[ ! -e "$file_path" ]]; then
        _bh_printerr "$error_message" "File does not exist"
        false
    elif [[ ! -f "$file_path" ]]; then
        _bh_printerr "$error_message" "File is not a regular file"
        false
    elif [[ ! -r "$file_path" ]]; then
        _bh_printerr "$error_message" "This process does not have permissions to read file"
        false
    else
        true
    fi 
}

function _bh_is_valid_directory() {
    local directory_path="$1"
    local error_message="\"$directory_path\" cannot be referenced"

    if [[ ! -e "$directory_path" ]]; then
        _bh_printerr "$error_message" "Directory does not exist"
        false
    elif [[ ! -d "$directory_path" ]]; then
        _bh_printerr "$error_message" "Directory is not a regular directory"
        false
    elif [[ ! -r "$directory_path" ]]; then
        _bh_printerr "$error_message" "This process does not have permissions to read directory"
        false
    else
        true
    fi 
}

function _bh_safe_source() {
    local file_path="$1"
    _bh_is_valid_file "$file_path" && source "$file_path"
}

function _bh_is_ostype_set() {
    if [[ -z "$OSTYPE" ]]; then
        printf "[ERROR] OSTYPE not set. Cannot run platform specific scripts.\n"
        false
    else
        true
    fi 
}

function _bh_is_mac() {
    _bh_is_ostype_set && [[ "$OSTYPE" == darwin* ]]
}

function _bh_is_linux() {
    _bh_is_ostype_set && [[ "$OSTYPE" == linux* ]]
}

function _bh_is_wsl() {
    [[ -n "$WSL_DISTRO_NAME" ]]
}

function _bh_exists_on_path() {
    local path_to_add="$1"
    [[ "$PATH" == *":$path_to_add:"* ]]
}

function _bh_prepend_path() {
    local path_to_add="$1"
    _bh_is_valid_directory "$path_to_add" || return
    _bh_exists_on_path "$path_to_add" || PATH="${path_to_add}${PATH:+":$PATH"}" 
}

function _bh_append_path() {
    local path_to_add="$1"
    _bh_is_valid_directory "$path_to_add" || return
    _bh_exists_on_path "$path_to_add" || PATH="${PATH:+"$PATH:"}${path_to_add}" 
}



################################################################################
# Homebrew
################################################################################
if _bh_is_mac; then
    local _bh_homebrew_path="/opt/homebrew/bin/brew"
    if _bh_is_valid_file "$_bh_homebrew_path" &> /dev/null; then
        eval $("$_bh_homebrew_path" shellenv)
    else
        _bh_printerr "Brew not installed"
    fi
fi


################################################################################
# Aliases
################################################################################

alias dots='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $argv'
alias ll='ls -lA'


################################################################################
# Other Cleanup
################################################################################

export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
