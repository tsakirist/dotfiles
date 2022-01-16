local M = {}

---Creates a new mapping
---@param mode string|table: can be for example 'n', 'i', 'v' or { 'n', 'i', 'v' }
---@param lhs string: the left hand side
---@param rhs string: the right hand side
---@param opts table: a table containing the mapping's options e.g. silent, nnoremap
function M.map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    if type(mode) ~= "table" then
        mode = { mode }
    end
    for i = 1, #mode do
        vim.api.nvim_set_keymap(mode[i], lhs, rhs, options)
    end
end

return M
