local M = {}

--- A list with the current active buffers where LSP has attached.
M.buffers = {}

--- Whether inlay_hints are globally enabled or not.
M.inlay_hints_enabled = false

--- Handler for the 'BufDelete' event, to delete the buffer from the active buffer list.
---@param bufnr number: The number of the buffer.
local function on_bufdelete(bufnr)
    for index, buffer in ipairs(M.buffers) do
        if buffer == bufnr then
            table.remove(M.buffers, index)
            break
        end
    end
end

--- A hook that reacts on the removal of a buffer and updates the active buffer list.
local function setup_bufdelete_hook()
    vim.api.nvim_create_autocmd("BufDelete", {
        group = vim.api.nvim_create_augroup("tt.InlayHints", { clear = true }),
        callback = function(args)
            on_bufdelete(args.buf)
        end,
    })
end

setup_bufdelete_hook()

--- Toggles inlay-hints on or off for all listed buffers.
function M.toggle_inlay_hints()
    M.inlay_hints_enabled = not M.inlay_hints_enabled
    for _, bufnr in ipairs(M.buffers) do
        vim.lsp.inlay_hint.enable(M.inlay_hints_enabled, { bufnr = bufnr })
    end
end

--- Enable inlay-hints when the LSP attaches to the buffer.
---@param client any: The LSP client.
---@param bufnr number: The number of the buffer.
function M.on_attach(client, bufnr)
    if client.supports_method "textDocument/inlayHint" then
        table.insert(M.buffers, bufnr)
        vim.lsp.inlay_hint.enable(M.inlay_hints_enabled, { bufnr = bufnr })
    end
end

local utils = require "tt.utils"
utils.map("n", "<leader>it", M.toggle_inlay_hints, { desc = "Toggle LSP inlay hints" })

return M
