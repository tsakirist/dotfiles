local wezterm = require("wezterm")
local wezterm_bindings = require("wezterm_bindings")
local wezterm_extras = require("wezterm_extras")
local config = wezterm.config_builder()

-- Terminal
config.initial_cols = 160
config.initial_rows = 52

-- Color
config.color_scheme = "carbonfox"
local colorscheme = wezterm.color.get_builtin_schemes()[config.color_scheme]
local colors = {
	black = colorscheme.ansi[1],
	blue = colorscheme.ansi[5],
	magenta = colorscheme.ansi[6],
	white = colorscheme.ansi[8],
}

-- Font
config.font = wezterm.font("CaskaydiaMono Nerd Font")
config.font_size = 12

-- Tab
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_and_split_indices_are_zero_based = true

-- Window
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.9
config.adjust_window_size_when_changing_font_size = false

-- Pane
config.pane_focus_follows_mouse = false

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.animation_fps = 1

-- Command palette
config.command_palette_fg_color = colors.blue
config.command_palette_bg_color = colors.black
config.command_palette_font_size = 13

-- Bindings
config.disable_default_key_bindings = true
config.keys = wezterm_bindings.keys
config.key_tables = wezterm_bindings.key_tables
config.mouse_bindings = wezterm_bindings.mouse_bindings

-- Show which key table is active in the status area
wezterm.on("update-status", function(window)
	local active_key_table = window:active_key_table()
	active_key_table = active_key_table and "[Mode]: " .. active_key_table or ""

	window:set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = colors.magenta } },
		{ Text = active_key_table },
	}))
end)

-- Set the tab title, preferring any custom title manually set, or falls back to the cwd
wezterm.on("format-tab-title", function(tab)
	local tab_title = tab.tab_title

	local title
	if tab_title and #tab_title > 0 then
		title = tab.tab_titlee
	else
		title = wezterm_extras.get_cwd(tab)
	end

	return string.format("  %s•%s  ", tab.tab_index, title)
end)

return config
