local M = {}

function M.setup()
    require("cybu").setup {
        display_time = 500,
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
