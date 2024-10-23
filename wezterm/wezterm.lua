local wezterm = require("wezterm")
local wezterm_extras = require("wezterm_extras")
local action = wezterm.action
local config = wezterm.config_builder()

-- Terminal
config.initial_cols = 160
config.initial_rows = 50

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
config.hide_tab_bar_if_only_one_tab = true
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

-- Keybinds
config.disable_default_key_bindings = true

local keys = {
	{
		key = "p",
		mods = "CTRL|SHIFT",
		action = action.ActivateCommandPalette,
	},
	{
		key = "O",
		mods = "CTRL|SHIFT",
		action = action.ShowDebugOverlay,
	},
	{
		key = "+",
		mods = "CTRL|SHIFT",
		action = action.IncreaseFontSize,
	},
	{
		key = "_",
		mods = "CTRL|SHIFT",
		action = action.DecreaseFontSize,
	},
	{
		key = "0",
		mods = "CTRL",
		action = action.ResetFontSize,
	},
	{
		key = "c",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CopyTo("Clipboard"),
	},
	{
		key = "v",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	{
		key = "w",
		mods = "SUPER",
		action = action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "W",
		mods = "SUPER",
		action = action.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "9",
		mods = "CTRL",
		action = action.ShowTabNavigator,
	},
	{
		key = "F11",
		action = action.ToggleFullScreen,
	},
	{
		key = "z",
		mods = "CTRL|SHIFT",
		action = action.TogglePaneZoomState,
	},
	{
		key = "t",
		mods = "CTRL|SHIFT",
		action = action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "n",
		mods = "CTRL|SHIFT",
		action = action.SpawnWindow,
	},
	{
		key = "|",
		mods = "CTRL|SHIFT",
		action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "Enter",
		mods = "CTRL|SHIFT",
		action = action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "Tab",
		mods = "CTRL",
		action = action.ActivateTabRelative(1),
	},
	{
		key = "Tab",
		mods = "CTRL|SHIFT",
		action = action.ActivateTabRelative(-1),
	},
	{
		key = "LeftArrow",
		mods = "ALT",
		action = action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "RightArrow",
		mods = "ALT",
		action = action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "UpArrow",
		mods = "ALT",
		action = action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "DownArrow",
		mods = "ALT",
		action = action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "LeftArrow",
		mods = "CTRL|SHIFT",
		action = action.ActivatePaneDirection("Left"),
	},
	{
		key = "RightArrow",
		mods = "CTRL|SHIFT",
		action = action.ActivatePaneDirection("Right"),
	},
	{
		key = "UpArrow",
		mods = "CTRL|SHIFT",
		action = action.ActivatePaneDirection("Up"),
	},
	{
		key = "DownArrow",
		mods = "CTRL|SHIFT",
		action = action.ActivatePaneDirection("Down"),
	},
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = action.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = action.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = action.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = action.ActivatePaneDirection("Down"),
	},
	{
		key = "r",
		mods = "CTRL|SHIFT",
		action = action.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},
	{
		key = "a",
		mods = "CTRL|SHIFT",
		action = action.ActivateKeyTable({
			name = "activate_pane",
			one_shot = true,
		}),
	},
	{
		key = "a",
		mods = "ALT",
		action = action.PaneSelect,
	},
	{
		key = "x",
		mods = "CTRL|SHIFT",
		action = action.ActivateCopyMode,
	},
	{
		key = "k",
		mods = "SUPER",
		action = action.Multiple({
			action.ClearScrollback("ScrollbackAndViewport"),
			action.SendKey({ key = "L", mods = "CTRL" }),
		}),
	},
}

config.keys = wezterm_extras.merge_keys(keys, wezterm_extras.keys)

-- Key tables
config.key_tables = {
	resize_pane = {
		{ key = "LeftArrow", action = action.AdjustPaneSize({ "Left", 5 }) },
		{ key = "RightArrow", action = action.AdjustPaneSize({ "Right", 5 }) },
		{ key = "UpArrow", action = action.AdjustPaneSize({ "Up", 5 }) },
		{ key = "DownArrow", action = action.AdjustPaneSize({ "Down", 5 }) },
		{ key = "h", action = action.AdjustPaneSize({ "Left", 5 }) },
		{ key = "l", action = action.AdjustPaneSize({ "Right", 5 }) },
		{ key = "k", action = action.AdjustPaneSize({ "Up", 5 }) },
		{ key = "j", action = action.AdjustPaneSize({ "Down", 5 }) },
		{ key = "Escape", action = "PopKeyTable" },
	},
	-- No keybind for this yet, `Action.PaneSelect` is more suitable instead of this
	activate_pane = {
		{ key = "LeftArrow", action = action.ActivatePaneDirection("Left") },
		{ key = "RightArrow", action = action.ActivatePaneDirection("Right") },
		{ key = "UpArrow", action = action.ActivatePaneDirection("Up") },
		{ key = "DownArrow", action = action.ActivatePaneDirection("Down") },
		{ key = "h", action = action.ActivatePaneDirection("Left") },
		{ key = "l", action = action.ActivatePaneDirection("Right") },
		{ key = "k", action = action.ActivatePaneDirection("Up") },
		{ key = "j", action = action.ActivatePaneDirection("Down") },
		{ key = "Escape", action = "PopKeyTable" },
	},
}

-- Mouse
-- NOTE: Shift mod needs to be pressed for these
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = action.OpenLinkAtMouseCursor,
	},
	{
		event = { Down = { streak = 1, button = { WheelUp = 1 } } },
		mods = "CTRL",
		action = action.IncreaseFontSize,
	},
	{
		event = { Down = { streak = 1, button = { WheelDown = 1 } } },
		mods = "CTRL",
		action = action.DecreaseFontSize,
	},
}

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

return config
