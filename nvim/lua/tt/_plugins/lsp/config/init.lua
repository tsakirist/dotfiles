local M = {}

local function on_attach(client, bufnr)
    require("tt._plugins.lsp.config.keymaps").on_attach(client, bufnr)
    require("tt._plugins.lsp.config.format").on_attach(client, bufnr)
    require("tt._plugins.lsp.config.highlight").on_attach(client, bufnr)
    require("tt._plugins.lsp.config.symbols").on_attach(client, bufnr)
end

function M.setup()
    require("tt._plugins.lsp.config.handlers").setup()
    require("tt._plugins.lsp.config.servers").setup(on_attach)
end

local utils = require "tt.utils"
utils.map("n", "<leader>li", "<Cmd>LspInfo<CR>")

return M
