local M = {}

function M.on_attach(client, bufnr)
    if client.supports_method "textDocument/documentHighlight" then
        vim.api.nvim_create_autocmd("CursorHold", {
            group = vim.api.nvim_create_augroup("_lsp_document_highlight", { clear = true }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.document_highlight()
            end,
        })

        vim.api.nvim_create_autocmd("CursorMoved", {
            group = vim.api.nvim_create_augroup("_lsp_document_highlight", { clear = false }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.clear_references()
            end,
        })
    end
end

return M
