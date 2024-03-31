local Set = require "tt.utils.set"

local M = {}

--- Filetypes along with their format on save status.
---@type table<string, boolean>
M.filetypes = {
    cpp = false,
    sh = true,
    lua = true,
    javascript = true,
    javascriptreact = true,
    typescript = true,
    typescriptreact = true,
}

--- A set of buffers for which format should be disabled.
---@type Set
M.ignrored_buffers = Set()

--- Returns whether the buffer should be formatted, e.g. is not included in the ignored set.
---@param bufnr integer
---@return boolean
function M.should_format_buffer(bufnr)
    return not M.ignrored_buffers:contains(bufnr)
end

--- Toggles the format status of the current buffer.
---@param bufnr number
function M.toggle_buffer(bufnr)
    M.ignrored_buffers:insert_or_remove(bufnr)
    vim.notify(
        string.format(
            "%s format for buffer #%d: '%s'",
            M.ignrored_buffers:contains(bufnr) and "Disabled" or "Enabled",
            bufnr,
            vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:t")
        ),
        vim.log.levels.INFO,
        { title = "Format" }
    )
end

--- Checks whether an entry exists for the given filetype.
---@param filetype string
---@return boolean
function M.has_filetype(filetype)
    return M.filetypes[filetype] ~= nil
end

--- Checks whether the filetype should be formatted or not.
---@param filetype string
---@return boolean
function M.should_format_filetype(filetype)
    return M.filetypes[filetype]
end

--- Checks whether format on save is enabled for the current filetype and buffer.
--- Treats non-existing filetype entries as having formatting enabled.
---@param filetype string
---@param bufnr integer
---@return boolean
function M.should_format(filetype, bufnr)
    if M.has_filetype(filetype) then
        if M.should_format_filetype(filetype) then
            return M.should_format_buffer(bufnr)
        end
        return false
    end
    return true
end

--- Toggle auto-formatting for the current filetype.
--- Treats non-existing entries as having formatting enabled.
---@param filetype string
function M.toggle_filetype(filetype)
    if M.has_filetype(filetype) then
        M.filetypes[filetype] = not M.filetypes[filetype]
    else
        M.filetypes[filetype] = false
    end
    vim.notify(
        string.format("%s format on save for '%s'", M.filetypes[filetype] and "Enabled" or "Disabled", filetype),
        vim.log.levels.INFO,
        { title = "Format" }
    )
end

function M.setup()
    --- Add a hook to update the ignored buffer set when a buffer gets deleted.
    vim.api.nvim_create_autocmd("BufDelete", {
        group = vim.api.nvim_create_augroup("tt.FormatUtils", { clear = true }),
        callback = function(args)
            M.ignrored_buffers:remove(args.buf)
        end,
    })

    local utils = require "tt.utils"

    utils.map("n", "<leader>tf", function()
        M.toggle_filetype(vim.bo.filetype)
    end, { desc = "Toggle format status for the current filetype" })

    utils.map("n", "<leader>tb", function()
        local bufnr = vim.api.nvim_get_current_buf()
        M.toggle_buffer(bufnr)
    end, { desc = "Toggle format status for the current buffer" })
end

return M
