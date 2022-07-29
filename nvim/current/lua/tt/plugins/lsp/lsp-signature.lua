local M = {}

function M.setup()
    require("lsp_signature").setup {
        bind = true, -- Mandatory, for border config to register
        doc_lines = 10, -- Number of doc lines to show
        handler_opts = { -- Options for floating window
            border = "rounded",
        },
        floating_window = false, -- Show hint in a floating window. Setting it to false in order to manually trigger it
        floating_window_above_cur_line = true, -- Try to place the floating above the current line when possible
        fix_pos = false, -- Set to true, the floating window will not auto-close until all parameters finished
        hint_enable = false, -- Virtual hint
        hint_prefix = " ", -- Show a prefix before the virtual text
        hint_scheme = "String", -- Hint's scheme
        hi_parameter = "Search", -- Parameter highlight
        padding = "", -- Character to pad on left and right of signature can be ' ', or '|' etc
        extra_trigger_chars = { -- Array of extra characters that will trigger signature completion
            "{",
        },
        always_trigger = false, -- Sometimes showing signature on a new line or in  the middle of parameter can be confusing
        auto_close_after = nil, -- Autoclose signature float win after x sec, disabled if nil
        toggle_key = "<M-x>", -- Toggle signature on or off in insert mode
        select_signature_key = "<M-n>", -- Cycle to next signature, e.g. '<M-n>' function overloading
    }
end

return M
