local M = {}

--- Filetypes along with their format on save status.
---@type table<string, boolean>
M.filetypes = {
    cpp = false,
    lua = true,
    rust = true,
    sh = true,
    typescript = true,
    typescriptreact = true,
}

--- Checks whether format on save is enabled for the current filetype.
---@param filetype string
---@return boolean
function M.should_format(filetype)
    return M.filetypes[filetype] == true
end

--- Limit formatting to 'null-ls', this call is synchronous
---@param bufnr number
function M.format(bufnr)
    vim.lsp.buf.format {
        filter = function(client)
            return client.name == "null-ls"
        end,
        bufnr = bufnr,
        {},
    }
end

--- Toggle auto-formatting for the current filetype.
---@param filetype string
function M.toggle_format(filetype)
    M.filetypes[filetype] = not M.filetypes[filetype]
    vim.notify(
        string.format("%s format on save for '%s'", M.filetypes[filetype] and "Enabled" or "Disabled", filetype),
        vim.log.levels.INFO,
        { title = "Format" }
    )
end

--- After LSP attaches to the buffer, create an autocommand that will format on save.
---@param client any
---@param bufnr number
function M.on_attach(client, bufnr)
    if client.supports_method "textDocument/formatting" then
        local group = vim.api.nvim_create_augroup("_format_on_save", { clear = false })
        vim.api.nvim_clear_autocmds { group = group, buffer = bufnr }
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            buffer = bufnr,
            callback = function()
                local filetype = vim.bo[bufnr].filetype
                if M.should_format(filetype) then
                    M.format(bufnr)
                end
            end,
            desc = "Format on save",
        })
    end
end

local utils = require "tt.utils"
utils.map("n", "<leader>tf", function()
    M.toggle_format(vim.bo.filetype)
end, { desc = "Toggle format on save for the current filetype" })

return M
