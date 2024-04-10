local _bh_fnm_path="/opt/homebrew/bin/fnm"
if _bh_is_valid_file "$_bh_fnm_path" &> /dev/null; then
    eval "$(fnm env --use-on-cd)"
else
    _bh_printerr "fnm not installed"
fi

