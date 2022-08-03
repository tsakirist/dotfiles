local M = {}

---Returns the colors that are used by the current theme.
---@return table: The color table used by the theme.
function M.colors()
    return require("nightfox.palette").load "nordfox"
end

function M.setup()
    local Color = require "nightfox.lib.color"
    local colors = M.colors()

    local custom_colors = {
        bg = Color.from_hex(colors.bg1):brighten(0.05),
        fg = Color.from_hex(colors.bg1):brighten(0.50),
    }

    require("nightfox").setup {
        options = {
            compile_path = vim.fn.stdpath "cache" .. "/nightfox", -- Compile path directory
            compile_file_suffix = "_compiled", -- The suffix compiled file will have
            dim_inactive = false, -- Dim inactive windows
            terminal_colors = true, -- Configure the colors used when opening :terminal
            transparent = false, -- Disable setting the background color
            styles = {
                comments = "italic",
                conditionals = "NONE",
                constants = "bold",
                functions = "bold,italic",
                keywords = "NONE",
                numbers = "NONE",
                operators = "NONE",
                strings = "NONE",
                types = "NONE",
                variables = "bold",
            },
            inverse = {
                match_paren = false, -- Enable/Disable inverse highlighting for match parens
                visual = false, -- Enable/Disable inverse highlighting for visual selection
                search = false, -- Enable/Disable inverse highlighting for search
            },
        },
        specs = {
            nordfox = {
                git = {
                    changed = colors.blue.base,
                },
                syntax = {
                    builtin0 = colors.magenta.bright,
                },
            },
        },
        groups = {
            nordfox = {
                TelescopeBorder = {
                    fg = colors.bg0,
                    bg = colors.bg0,
                },
                TelescopeMatching = {
                    fg = colors.magenta,
                },
                TelescopePromptBorder = {
                    fg = custom_colors.bg1,
                    bg = custom_colors.bg1,
                },
                TelescopePromptNormal = {
                    fg = custom_colors.fg1,
                    bg = custom_colors.bg1,
                },
                TelescopePromptPrefix = {
                    fg = colors.magenta,
                    bg = custom_colors.bg1,
                },
                TelescopePromptTitle = {
                    fg = colors.bg1,
                    bg = colors.magenta,
                },
                TelescopePreviewTitle = {
                    fg = colors.bg1,
                    bg = colors.cyan,
                },
                TelescopePreviewNormal = {
                    bg = colors.bg0,
                },
                TelescopeResultsTitle = {
                    fg = colors.bg1,
                    bg = colors.magenta,
                },
                TelescopeResultsNormal = {
                    bg = colors.bg0,
                },
                TelescopeSelectionCaret = {
                    fg = colors.cyan,
                    bg = colors.bg0,
                },
                CmpItemKindFunction = {
                    fg = colors.magenta,
                },
                CmpItemKindMethod = {
                    fg = colors.magenta,
                },
                CmpWindowBorder = {
                    fg = colors.bg0,
                    bg = colors.bg0,
                },
                GpsItemKindFunction = {
                    fg = colors.magenta,
                    bg = colors.bg0,
                },
                GpsItemKindMethod = {
                    fg = colors.magenta,
                    bg = colors.bg0,
                },
                GpsItemKindProperty = {
                    fg = colors.blue,
                    bg = colors.bg0,
                },
                GpsItemKindClass = {
                    fg = colors.yellow,
                    bg = colors.bg0,
                },
                GpsItemKindKeyword = {
                    fg = colors.green,
                    bg = colors.bg0,
                },
                NvimSurroundHighlightTextObject = {
                    fg = colors.yellow,
                },
                FidgetTitle = {
                    fg = colors.cyan,
                },
                FidgetTask = {
                    fg = colors.magenta,
                },
                CybuCurrentSelection = {
                    fg = colors.magenta,
                },
            },
        },
    }

    vim.cmd.colorscheme "nordfox"
end

return M
