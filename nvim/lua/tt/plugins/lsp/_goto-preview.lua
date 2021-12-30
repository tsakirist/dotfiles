require("goto-preview").setup {
    width = 120, -- Width of the floating window
    height = 25, -- Height of the floating window
    border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
    opacity = 5, -- 0-100 opacity level of the floating window where 100 is fully transparent
    debug = false, -- Print debug information
    post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook
    default_mappings = false, -- Bind default mappings
    focus_on_open = true, -- Focus the floating window when opening it
    dismiss_on_move = false, -- Dismiss the floating window when moving the cursor
    resizing_mappings = true, -- Binds arrow keys to resizing the floating window
    force_close = true, -- Force close the last window of a buffer eve with unwritten changes. See :h nvim_win_close
    bufhidden = "wipe", -- This option specifies what happens when a buffer is no longer displayed in a window. See :h bufhidden
}

-- Setup goto-preview keymappings
local utils = require "tt.utils"

utils.map("n", "gp", "<Cmd>lua require('goto-preview').goto_preview_definition()<CR>")
utils.map("n", "gP", "<Cmd>lua require('goto-preview').close_all_win()<CR>")
