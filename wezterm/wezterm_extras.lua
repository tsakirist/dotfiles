local wezterm = require("wezterm")

local M = {}

function M.basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

function M.get_cwd(tab)
	local cwd = tab.active_pane.current_working_dir
	return M.basename(cwd.file_path)
end

function M.is_neovim(pane)
	local process_name = M.basename(pane:get_foreground_process_name())
	return process_name == "nvim"
end

-- Merges the two provided key tables and returns a new table
function M.merge_keys(t1, t2)
	local result = {}
	for _, v in ipairs(t1) do
		table.insert(result, v)
	end
	for _, v in pairs(t2) do
		table.insert(result, v)
	end
	return result
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local resize_amount = 5

-- Bind resize functionality to either send the action to wezterm or neovim
local function resize_key(key)
	return {
		key = key,
		mods = "ALT",
		action = wezterm.action_callback(function(win, pane)
			if M.is_neovim(pane) then
				win:perform_action({ SendKey = { key = key, mods = "ALT" } }, pane)
			else
				win:perform_action({ AdjustPaneSize = { direction_keys[key], resize_amount } }, pane)
			end
		end),
	}
end

M.keys = {
	resize_key("h"),
	resize_key("j"),
	resize_key("k"),
	resize_key("l"),
}

return M
