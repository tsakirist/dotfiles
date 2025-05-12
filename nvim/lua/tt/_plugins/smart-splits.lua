local M = {}

function M.setup()
    local smart_splits = require "smart-splits"

    smart_splits.setup {
        -- The amount of lines/columns to resize by at a time
        default_amount = 3,

        -- Cursor follows when swapping buffers
        cursor_follows_swapped_bufs = true,

        -- Cursor will move on the same row when moving between buffers regardless of line numbers
        move_cursor_same_row = true,
    }

    local utils = require "tt.utils"
    utils.map("n", "<M-h>", smart_splits.resize_left, { desc = "Resize window left" })
    utils.map("n", "<M-l>", smart_splits.resize_right, { desc = "Resize window right" })
    utils.map("n", "<C-w>h", smart_splits.move_cursor_left, { desc = "Move cursor left" })
    utils.map("n", "<C-w>j", smart_splits.move_cursor_down, { desc = "Move cursor down" })
    utils.map("n", "<C-w>k", smart_splits.move_cursor_up, { desc = "Move cursor up" })
    utils.map("n", "<C-w>l", smart_splits.move_cursor_right, { desc = "Move cursor right" })
end

return M
