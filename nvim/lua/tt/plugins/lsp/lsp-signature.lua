local M = {}

function M.setup()
    require("lsp_signature").on_attach {
        bind = true,
        doc_lines = 10,
        handler_opts = {
            border = "rounded",
        },
        floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
        floating_window_above_cur_line = true, -- try to place the floating above the current line when possible
        hint_enable = false, -- virtual hint enable
        hint_prefix = " ", -- show a prefix before the virtual text
        hint_scheme = "String",
        hi_parameter = "Search", -- parameter highlight
        toggle_key = "<M-x>", -- togle signature on or off
        padding = "", -- character to pad on left and right of signature can be ' ', or '|' etc
    }
end

return M
