local M = {}

function M.setup()
    local smart_splits = require "smart-splits"

    smart_splits.setup {
        -- The amount of lines/columns to resize by at a time
        default_amount = 3,

        -- Resize mode options
        resize_mode = {
            -- Key to exit persistent resize mode
            quit_key = "<ESC>",

            -- Keys to use for moving in resize mode
            -- in order of left, down, up' right
            resize_keys = { "h", "j", "k", "l" },

            -- Set to true to silence the notifications
            -- when entering/exiting persistent resize mode
            silent = true,
        },

        -- Disable tmux integration
        tmux_integration = false,
    }

    local utils = require "tt.utils"
    utils.map("n", "<leader>rs", smart_splits.start_resize_mode, { desc = "Start persistent resize mode" })
    utils.map("n", "<M-h>", smart_splits.resize_left, { desc = "Resize window left" })
    utils.map("n", "<M-j>", smart_splits.resize_down, { desc = "Resize window down" })
    utils.map("n", "<M-k>", smart_splits.resize_up, { desc = "Resize window up" })
    utils.map("n", "<M-l>", smart_splits.resize_right, { desc = "Resize window right" })
end

return M
