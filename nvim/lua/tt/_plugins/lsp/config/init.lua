local M = {}

function M.setup()
    require("tt._plugins.lsp.config.attach").setup()
    require("tt._plugins.lsp.config.handlers").setup()
    require("tt._plugins.lsp.config.servers").setup()
end

local utils = require "tt.utils"
utils.map("n", "<leader>li", vim.cmd.LspInfo)

return M
