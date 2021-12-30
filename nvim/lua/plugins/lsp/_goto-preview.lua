require("goto-preview").setup {
    width = 120, -- Width of the floating window
    height = 25, -- Height of the floating window
    border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
    opacity = 5, -- 0-100 opacity level of the floating window where 100 is fully transparent.
    debug = false, -- Print debug information
    post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
    default_mappings = false, -- Bind default mappings
    focus_on_open = true, -- Focus the floating window when opening it
    dismiss_on_move = true, -- Dismiss the foloating window when moving the cursor
}

-- Setup goto-preview keymappings
local utils = require "utils"

utils.map("n", "gp", "<Cmd>lua require('goto-preview').goto_preview_definition()<CR>")
utils.map("n", "gP", "<Cmd>lua require('goto-preview').close_all_win()<CR>")
