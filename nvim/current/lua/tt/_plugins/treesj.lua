local M = {}

function M.setup()
    require("treesj").setup {
        -- Use default keymaps
        use_default_keymaps = false,

        -- Node with syntax error will not be formatted
        check_syntax_error = true,

        -- Do not format the node, if the line after the join operation will be longer than max value
        max_join_length = 120,

        -- hold | start | end:
        -- hold: cursor follows the node/place on which it was called
        -- start: cursor jumps to the first symbol of the node being formatted
        -- end: cursor jumps to the last symbol of the node being formatted
        cursor_behavior = "hold",

        -- Notify about possible problems or not
        notify = true,
    }

    local utils = require "tt.utils"
    utils.map("n", "<leader>sj", "<Cmd>TSJToggle<CR>", { desc = "Split or join blokcks of code" })
end

return M
