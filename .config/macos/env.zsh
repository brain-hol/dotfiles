#!/usr/bin/env zsh

# Remap the Caps Lock key to Control
# See https://hidutil-generator.netlify.app
/usr/bin/hidutil property --set '{
    "UserKeyMapping": [
        {
            "HIDKeyboardModifierMappingSrc": 0x700000039,
            "HIDKeyboardModifierMappingDst": 0x7000000E4
	}
    ]
}'

# This can't be in .zshrc because it needs to be set before `/etc/zhsrc` is run.
# Otherwise Apple starts saving `.zsh_sessions`.
# See https://superuser.com/a/1610999 for more info.
/bin/launchctl setenv SHELL_SESSIONS_DISABLE 1

/bin/launchctl setenv XDG_CONFIG_HOME "$HOME/.config"
/bin/launchctl setenv XDG_CACHE_HOME "$HOME/.cache"
/bin/launchctl setenv XDG_DATA_HOME "$HOME/.local/share"
/bin/launchctl setenv XDG_STATE_HOME "$HOME/.local/state"

# You can't use variables declared with launchctl because they only take effect
# with processes spawned after they are set which this file is not.
/bin/launchctl setenv ZDOTDIR "$HOME/.config/zsh"
/bin/launchctl setenv NPM_CONFIG_USERCONFIG "$HOME/.config/npm/npmrc"
/bin/launchctl setenv DOCKER_CONFIG "$HOME/.config/docker"

