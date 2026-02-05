local format_utils = require "tt._plugins.format.utils"

local M = {}

--- Formats the current buffer, with optional customization through specified opts.
---@param opts? conform.FormatOpts
function M.format(opts)
    ---@type conform.FormatOpts
    local format_opts = vim.tbl_extend("force", {
        async = false,
        lsp_fallback = true,
        timeout_ms = 2500,
    }, opts or {})
    format_utils.run_pre_format_handlers(format_opts.bufnr)
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

--- Adds a pre format handler to be invoked before formatting for the given bufnr.
--- If no bufnr is provided or 0, it will use the current buffer.
---@param bufnr? Buffer
---@param handler fun()
function M.add_pre_format_handler(bufnr, handler)
    format_utils.add_pre_format_handler(bufnr, handler)
end

--- Removes a handler from the pre format handlers table for the given bufnr.
--- If no bufnr is provided or 0, it will use the current buffer.
---@param bufnr? Buffer
---@param handler? fun()
function M.remove_pre_format_handler(bufnr, handler)
    format_utils.remove_pre_format_handler(bufnr, handler)
end

function M.init()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end

function M.setup()
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
                M.format { bufnr = bufnr }
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
