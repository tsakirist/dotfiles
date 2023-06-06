local M = {}

function M.setup()
    require("cybu").setup {
        display_time = 750,
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
        behavior = {
            mode = {
                default = {
                    switch = "on_close",
                    view = "paging",
                },
            },
        },
    }

    local utils = require "tt.utils"
    utils.map("n", "<Tab>", "<Plug>(CybuNext)")
    utils.map("n", "<S-Tab>", "<Plug>(CybuPrev)")
end

return M
