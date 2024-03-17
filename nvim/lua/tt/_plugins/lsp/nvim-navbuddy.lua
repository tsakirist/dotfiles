local M = {}

function M.setup()
    local icons = require "tt.icons"

    require("nvim-navbuddy").setup {
        window = {
            border = "rounded",
            size = "75%",
        },
        icons = icons.kind,
    }

    local utils = require "tt.utils"
    utils.map("n", "<leader>nv", require("nvim-navbuddy").open, {
        desc = "Open navigation buddy for LSP symbols ",
    })
end

return M
