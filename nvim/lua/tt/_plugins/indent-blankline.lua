local M = {}

function M.setup()
    require("ibl").setup {
        scope = {
            enabled = true,
            show_start = false,
            show_end = false,
        },
        indent = {
            char = "│",
        },
        exclude = {
            filetypes = require("tt.common").ignored_filetypes,
        },
    }
end

return M
