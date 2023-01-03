local M = {}

function M.setup()
    require("cybu").setup {
        display_time = 500,
        position = {
            anchor = "center", -- Location of where the popup will open
            relative_to = "editor", -- Popup will open relative to either `win`, `cursor`, or `editor`
            max_win_height = 10, -- Number of lines to show
        },
        style = {
            highlights = {
                current_buffer = "CybuCurrentSelection",
            },
        },
    }
    local utils = require "tt.utils"
    utils.map("n", "<Tab>", "<Plug>(CybuLastusedNext)")
    utils.map("n", "<S-Tab>", "<Plug>(CybuLastusedPrev)")
end

return M
