local _bh_homebrew_path="/opt/homebrew/bin/brew"
if _bh_is_valid_file "$_bh_homebrew_path" &> /dev/null; then
    eval $("$_bh_homebrew_path" shellenv)
    fpath+="/opt/homebrew/share/zsh/site-functions"
else
    _bh_printerr "Brew not installed"
fi

