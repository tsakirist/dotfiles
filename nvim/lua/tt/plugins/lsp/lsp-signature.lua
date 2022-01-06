local M = {}

function M.setup()
    require("lsp_signature").on_attach {
        bind = true, -- Mandatory, for border config to register
        doc_lines = 10, -- Number of doc lines to show
        handler_opts = { -- Options for floating window
            border = "rounded",
        },
        floating_window = true, -- Show hint in a floating window, set to false for virtual text only mode
        floating_window_above_cur_line = true, -- Try to place the floating above the current line when possible
        fix_pos = false, -- Set to true, the floating window will not auto-close until all parameters finished
        hint_enable = false, -- Virtual hint enable
        hint_prefix = " ", -- Show a prefix before the virtual text
        hint_scheme = "String", -- Hint's scheme
        hi_parameter = "Search", -- Parameter highlight
        toggle_key = "<M-x>", -- Toggle signature on or off in insert mode
        padding = "", -- Character to pad on left and right of signature can be ' ', or '|' etc
        extra_trigger_chars = { -- Array of extra characters that will trigger signature completion
            '{',
        },
    }
end

return M
