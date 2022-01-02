local M = {}

function M.setup()
    local null_ls = require "null-ls"
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    null_ls.setup {
        sources = {
            -- Formatting
            formatting.prettierd,
            formatting.stylua,
            formatting.clang_format.with {
                extra_args = { "-style=file" },
            },
            formatting.shfmt.with {
                extra_args = { "-i", "4", "-bn", "-ci", "-sr" },
            },
            -- Diagnostics
            diagnostics.shellcheck,
            diagnostics.luacheck,
        },
    }
end

return M
