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

--- Checks whether an entry exists for the given filetype.
---@param filetype string
---@return boolean
function M.has_entry(filetype)
    return M.filetypes[filetype] ~= nil
end

--- Checks whether format on save is enabled for the current filetype.
--- Treats non-existing entries as having formatting enabled.
---@param filetype string
---@return boolean
function M.should_format(filetype)
    if M.has_entry(filetype) then
        return M.filetypes[filetype]
    end
    return true
end

--- Toggle auto-formatting for the current filetype.
--- Treats non-existing entries as having formatting enabled.
---@param filetype string
function M.toggle_format(filetype)
    if M.has_entry(filetype) then
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

--- Formats the current buffer, with optional customization through specified opts.
---@param opts? table
function M.format(opts)
    local default_opts = {
        async = false,
        lsp_fallback = true,
        timeout_ms = 2500,
    }
    local format_opts = vim.tbl_extend("force", default_opts, opts or {})
    require("conform").format(format_opts)
end

--- Returns a list of the formatters that are registered in conform.
---@return table: List with the formatter names.
function M.get_formatters()
    local registered_formatters = require("conform").list_all_formatters()
    local formatters = {}
    for _, formatter_info in ipairs(registered_formatters) do
        table.insert(formatters, formatter_info.name)
    end
    return formatters
end

function M.init()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end

function M.setup()
    require("conform").setup {
        formatters_by_ft = {
            cpp = { "clang-format" },
            lua = { "stylua" },
            sh = { "shfmt" },
            javascript = { "prettierd" },
            javascriptreact = { "prettierd" },
            typescript = { "prettierd" },
            typescriptreact = { "prettierd" },
            ["*"] = { "codespell" },
        },
        formatters = {
            shfmt = {
                prepend_args = { "-i", "4", "-bn", "-ci", "-sr" },
            },
            ["clang-format"] = {
                prepend_args = { "-style=file" },
            },
        },
        format_on_save = function(bufnr)
            local filetype = vim.bo[bufnr].filetype
            if M.should_format(filetype) then
                M.format()
            end
        end,
    }

    local utils = require "tt.utils"

    utils.map("n", "<leader>ci", "<Cmd>ConformInfo<CR>", { desc = "Show conform information" })

    utils.map("n", "<leader>tf", function()
        M.toggle_format(vim.bo.filetype)
    end, { desc = "Toggle format on save for the current filetype" })

    utils.map({ "n", "v" }, "<leader>fR", function()
        require("conform").format { formatters = { "injected" }, timeout_ms = 2500 }
    end, { desc = "Format injected code blocks for the current buffer" })

    utils.map({ "n", "v" }, "<leader>fr", function()
        M.format { async = true }
    end, { desc = "Format the current buffer" })
end

return M
