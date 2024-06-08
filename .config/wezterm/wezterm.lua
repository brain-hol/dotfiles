local wezterm = require "wezterm"
local config = wezterm.config_builder()

config.color_scheme = "nord"

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

config.initial_cols = 120
config.initial_rows = 36
config.quit_when_all_windows_are_closed = false
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
config.font_size = 14
config.window_close_confirmation = "NeverPrompt"

config.native_macos_fullscreen_mode = true

config.keys = {
    {
        key = "f",
        mods = "CMD|CTRL",
        action = wezterm.action.ToggleFullScreen,
    },
}

return config
