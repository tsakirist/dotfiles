local M = {}

function M.setup()
    require("neogen").setup {
        --- Enables Neogen capabilities
        enabled = true,

        --- Go to annotation after insertion, and change to insert mode
        input_after_comment = true,

        --- Use a snippet engine to generate annotations
        snippet_engine = "luasnip",

        --- Enables placeholders when inserting annotation
        enable_placeholders = true,

        --- Placeholders used during annotation expansion
        placeholders_text = {
            ["description"] = "[...description]",
            ["tparam"] = "[...tparam]",
            ["parameter"] = "[...parameter]",
            ["return"] = "[...return]",
            ["class"] = "[...class]",
            ["throw"] = "[...throw]",
            ["varargs"] = "[...varargs]",
            ["type"] = "[...type]",
            ["attribute"] = "[...attribute]",
            ["args"] = "[...args]",
            ["kwargs"] = "[...kwargs]",
        },

        --- Placeholders highlights to use. If you don't want custom highlight, pass "None"
        placeholders_hl = "DiagnosticHint",
    }

    local utils = require "tt.utils"
    utils.map("n", "<leader>ng", require("neogen").generate, { desc = "Generate documentation" })
end

return M
