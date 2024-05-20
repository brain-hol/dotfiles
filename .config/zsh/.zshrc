################################################################################
# History
################################################################################
setopt SHARE_HISTORY
HISTFILE="$XDG_STATE_HOME/zsh_history"
HISTSIZE=1000000 # In memory
SAVEHIST=1000000 # In file


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
# Aliases
################################################################################

alias ll='ls -la'
alias dots='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $argv'


################################################################################
# Path
################################################################################

_bh_prepend_path $HOME/.local/bin


################################################################################
# disabled JetBrains Toolbox
################################################################################

# _bh_append_path "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"


# Source every symlink or file in conf.d
# See https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers about the for loop glob
bh_conf_d_dir="${XDG_CONFIG_HOME}/zsh/conf.d"

if [[ -d "${bh_conf_d_dir}" ]]; then
    for file in "${bh_conf_d_dir}"/*(.,@N); do
        if [[ -r "${file}" && -f "${file}" ]]; then
            source "${file}"
        fi
    done
fi

# Do autocomplete loading at the end so that individual files can add to fpath
 zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
 autoload -Uz compinit && compinit -d $XDG_CACHE_HOME/zcompdump

