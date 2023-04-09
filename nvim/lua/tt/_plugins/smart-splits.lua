local M = {}

function M.setup()
    require("smart-splits").setup {
        -- The amount of lines/columns to resize by at a time
        default_amount = 3,

        -- Resize mode options
        resize_mode = {
            -- Key to exit persistent resize mode
            quit_key = "<ESC>",

            -- Keys to use for moving in resize mode
            -- in the order of left, down, up, right
            resize_keys = { "h", "j", "k", "l" },

            -- Set to true to silence notifications
            silent = true,
        },
    }

    local utils = require "tt.utils"
    utils.map("n", "<leader>rs", require("smart-splits").start_resize_mode, {
        desc = "Start interactive resize mode",
    })
end

return M
