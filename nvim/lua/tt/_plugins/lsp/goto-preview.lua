local M = {}

function M.setup()
    local utils = require "tt.utils"

    local goto_preview = require "goto-preview"
    goto_preview.setup {
        width = 120, -- Width of the floating window
        height = 25, -- Height of the floating window
        border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
        opacity = 5, -- 0-100 opacity level of the floating window where 100 is fully transparent
        default_mappings = false, -- Bind default mappings
        focus_on_open = true, -- Focus the floating window when opening it
        dismiss_on_move = false, -- Dismiss the floating window when moving the cursor
        resizing_mappings = false, -- Binds arrow keys to resizing the floating window
        force_close = true, -- Force close the last window of a buffer eve with unwritten changes. See :h nvim_win_close
        bufhidden = "wipe", -- Specifies what happens when a buffer is no longer displayed in a window. See :h bufhidden
        debug = false, -- Print debug information

        -- Setup a post_open_hook that gets called right before setting the cursor position in the new floating window
        post_open_hook = function(bufnr, window)
            -- Set a keymap that will close the floating window
            utils.map("n", "q", function()
                vim.api.nvim_win_close(window, true)
            end, { buffer = bufnr })
        end,
    }

    utils.map("n", "gp", goto_preview.goto_preview_definition)
    utils.map("n", "gi", goto_preview.goto_preview_implementation)
    utils.map("n", "gP", goto_preview.close_all_win)
end

return M
