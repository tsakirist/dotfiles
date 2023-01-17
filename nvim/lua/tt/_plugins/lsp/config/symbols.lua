local M = {}

function M.on_attach(client, bufnr)
    if client.supports_method "textDocument/documentSymbols" then
        vim.g.navic_silence = true
        require "nvim-navic".attach(client, bufnr)
    end
end

return M
