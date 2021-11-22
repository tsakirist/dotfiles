local utils = {}

---Creates a new mapping
---@param mode string: mode which can be either 'n', 'i', 'v', 'c', 't', 'x'
---@param lhs string: the left hand side
---@param rhs string: the right hand side
---@param opts table: a table containing the mapping's options e.g. silent, nnoremap
function utils.map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

return utils
