local M = {}

function M.setup()
    require("indent_blankline").setup {
        -- char_list = { '|', '¦', '┆', '┊' },
        char = "│", -- Specifies the character to be used as indent line
        disable_with_no_list = true, -- Disables this plugin when `nolist` is set
        stricts_tabs = true, -- When on, if there is a single tab in a line, only tabs are used to calculate the indentation level
        use_treesitter = true, -- Use treesitter to calculate indentation when possible
        show_first_indent_level = false, -- Displays indentation in the first column
        show_trailing_blankline_indent = false, -- Displays a trailing indentation guide on blank lines, to match the indentation of surrounding code
        show_end_of_line = true, --  Displays the end of line character set by listchars
        show_current_context = true, -- Use treesitter to determine the current context
        show_current_context_start = true, -- Apply highlighting to the first line of current cnotext, by default will 'underline'
        show_current_context_start_on_current_line = false, -- Show context_start even when cursor is on the same line
        buftype_exclude = { "terminal" }, -- Specifies a list of buftype values for which this plugin is not enabled
        filetype_exclude = { -- Specifies a list of filetype values for which this plugin is not enabled
            "help",
            "startify",
            "gitcommit",
            "vistakind",
            "packer",
            "mason.nvim",
            "neo-tree-popup",
        },
        context_patterns = { -- Specifies a list of lua patterns that are used to match against treesitter
            "class",
            "function",
            "method",
            "^if",
            "^while",
            "^for",
            "^try",
            "except",
            "argument_list",
        },
    }
end

return M
