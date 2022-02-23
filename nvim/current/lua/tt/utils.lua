local M = {}

---Creates a new mapping
---@param mode string|table: can be for example 'n', 'i', 'v' or { 'n', 'i', 'v' }
---@param lhs string: the left hand side
---@param rhs string|function: the right hand side
---@param opts table: a table containing the mapping's options e.g. silent, remap
function M.map(mode, lhs, rhs, opts)
    local options = { silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

return M
