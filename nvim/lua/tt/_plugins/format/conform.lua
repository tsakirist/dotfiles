local M = {}

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
    local format_utils = require "tt._plugins.format.utils"
    format_utils.setup()

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
            if format_utils.should_format(filetype, bufnr) then
                M.format()
            end
        end,
    }

    local utils = require "tt.utils"

    utils.map("n", "<leader>ci", "<Cmd>ConformInfo<CR>", { desc = "Show conform information" })

    utils.map({ "n", "v" }, "<leader>fr", function()
        M.format { async = true }
    end, { desc = "Format the current buffer" })

    utils.map({ "n", "v" }, "<leader>fR", function()
        require("conform").format { formatters = { "injected" }, timeout_ms = 2500 }
    end, { desc = "Format injected code blocks for the current buffer" })
end

return M
