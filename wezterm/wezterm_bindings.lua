local wezterm = require("wezterm")
local wezterm_extras = require("wezterm_extras")
local action = wezterm.action

local M = {}

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
		key = ")",
		mods = "CTRL|SHIFT",
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
		action = action.SplitHorizontal({ domain = "CurrentPaneDomain", cwd = wezterm.home_dir }),
	},
	{
		key = "Enter",
		mods = "CTRL|SHIFT",
		action = action.SplitVertical({ domain = "CurrentPaneDomain", cwd = wezterm.home_dir }),
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
	{
		key = "r",
		mods = "SUPER",
		action = action.PromptInputLine({
			description = "Enter new tab name:",
			action = wezterm.action_callback(function(window, _, line)
				-- If 'ESC' is pressed, the line will be nil
				-- If 'CR' is pressed, the line will be an empty string
				if line == nil then
					return
				end
				-- Will either set the new tab title to the line or fallback to the default mechanism
				window:active_tab():set_title(line)
			end),
		}),
	},
}

M.keys = wezterm_extras.merge_keys(keys, wezterm_extras.keys)

M.key_tables = {
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

-- NOTE: Shift mod needs to be pressed for these
M.mouse_bindings = {
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

return M
