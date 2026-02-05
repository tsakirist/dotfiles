local Set = require "tt.utils.set"

local M = {}

---@alias Filetype string
---@alias Buffer integer

--- Filetypes along with their format on save status.
---@type table<Filetype, boolean>
M.filetypes = {
    cpp = true,
    sh = true,
    lua = true,
    javascript = true,
    javascriptreact = true,
    typescript = true,
    typescriptreact = true,
}

--- A set of buffers for which format should be disabled.
---@type Set
M.ignored_buffers = Set()

--- Set of handlers for each buffer to run before formatting.
---@type table<Buffer, table<fun()>>
M.pre_format_handlers = {}

--- Helper that gets the current buffer number in case the bufnr is not supplied or 0.
--- @param bufnr? Buffer
--- @return Buffer
local function resolve_bufnr(bufnr)
    if not bufnr or bufnr == 0 then
        return vim.api.nvim_get_current_buf()
    end
    return bufnr
end

--- Returns whether the buffer should be formatted, e.g. is not included in the ignored set.
---@param bufnr Buffer
---@return boolean
function M.should_format_buffer(bufnr)
    return not M.ignored_buffers:contains(bufnr)
end

--- Toggles the format status of the current buffer.
---@param bufnr Buffer
function M.toggle_buffer(bufnr)
    M.ignored_buffers:insert_or_remove(bufnr)
    vim.notify(
        string.format(
            "%s format for buffer #%d: '%s'",
            M.ignored_buffers:contains(bufnr) and "Disabled" or "Enabled",
            bufnr,
            vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:t")
        ),
        vim.log.levels.INFO,
        { title = "Format" }
    )
end

--- Checks whether an entry exists for the given filetype.
---@param filetype Filetype
---@return boolean
function M.has_filetype(filetype)
    return M.filetypes[filetype] ~= nil
end

--- Checks whether the filetype should be formatted or not.
---@param filetype Filetype
---@return boolean
function M.should_format_filetype(filetype)
    return M.filetypes[filetype]
end

--- Checks whether format on save is enabled for the current filetype and buffer.
--- Treats non-existing filetype entries as having formatting enabled.
---@param filetype Filetype
---@param bufnr Buffer
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
---@param filetype Filetype
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

--- Adds a handler to be invoked before formatting for the given buffer.
--- If no bufnr is provided or 0, it will use the current buffer.
---@param bufnr? Buffer
---@param handler fun()
function M.add_pre_format_handler(bufnr, handler)
    bufnr = resolve_bufnr(bufnr)

    local handlers = M.pre_format_handlers[bufnr] or {}
    table.insert(handlers, handler)
    M.pre_format_handlers[bufnr] = handlers
end

--- Removes a pre format handler from a specific buffer.
--- If no bufnr is provided or 0, it will use the current buffer.
--- If no handler is provided, all handlers for the buffer are removed.
---@param bufnr? Buffer
---@param handler? fun()
function M.remove_pre_format_handler(bufnr, handler)
    bufnr = resolve_bufnr(bufnr)

    local handlers = M.pre_format_handlers[bufnr]
    if not handlers then
        return
    end

    if not handler then
        M.pre_format_handlers[bufnr] = nil
        return
    end

    for i, h in ipairs(handlers) do
        if h == handler then
            table.remove(handlers, i)
            break
        end
    end

    if #handlers == 0 then
        M.pre_format_handlers[bufnr] = nil
    end
end

--- Runs all pre format handlers for the given buffer.
--- If no bufnr is provided or 0, it will use the current buffer.
---@param bufnr? Buffer
function M.run_pre_format_handlers(bufnr)
    bufnr = resolve_bufnr(bufnr)

    local handlers = M.pre_format_handlers[bufnr] or {}
    for _, handler in ipairs(handlers) do
        handler()
    end
end

--- Handler to be invoked when a buffer is deleted.
---@param bufnr Buffer
local function on_bufdelete(bufnr)
    M.ignored_buffers:remove(bufnr)
    M.remove_pre_format_handler(bufnr)
end

function M.setup()
    --- Add a hook to update internal states when a buffer is deleted
    vim.api.nvim_create_autocmd("BufDelete", {
        group = vim.api.nvim_create_augroup("tt.FormatUtils", { clear = true }),
        callback = function(args)
            on_bufdelete(args.buf)
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
