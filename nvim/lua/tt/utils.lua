local M = {}

--- Creates a new mapping
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

--- Returns the appropriate file separator according to the current OS.
---@return string: The appropriate file separator.
function M.file_separator()
    if jit and jit.os == "Windows" then
        return "\\"
    end
    return "/"
end

--- Joins the passed arguments with the appropriate file separator.
---@vararg any: The paths to join.
---@return string: The final joined path.
function M.join_paths(...)
    return table.concat({ ... }, M.file_separator())
end

return M
