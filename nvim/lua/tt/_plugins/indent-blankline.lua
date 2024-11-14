local M = {}

function M.setup()
    require("ibl").setup {
        scope = {
            enabled = false,
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
