local M = {}

function M.setup()
    --- Set the currently used theme in the Module
    M.theme = "nordfox"

    local colors = M.colors()

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
                CybuCurrentSelection = {
                    fg = colors.magenta,
                },
                DressingBorder = {
                    fg = colors.blue,
                    bg = colors.bg1,
                },
                DressingInput = {
                    fg = colors.magenta,
                    bg = colors.bg1,
                },
                FidgetTask = {
                    fg = colors.magenta,
                },
                FidgetTitle = {
                    fg = colors.cyan,
                },
                GpsItemKindClass = {
                    fg = colors.yellow,
                    bg = colors.bg0,
                },
                GpsItemKindFunction = {
                    fg = colors.magenta,
                    bg = colors.bg0,
                },
                GpsItemKindKeyword = {
                    fg = colors.green,
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
                NvimSurroundHighlightTextObject = {
                    fg = colors.yellow,
                },
                TelescopeBorder = {
                    fg = colors.bg0,
                    bg = colors.bg0,
                },
                TelescopeMatching = {
                    fg = colors.magenta,
                },
                TelescopePreviewNormal = {
                    bg = colors.bg0,
                },
                TelescopePreviewTitle = {
                    fg = colors.bg1,
                    bg = colors.cyan,
                },
                TelescopePromptBorder = {
                    fg = colors.bg0,
                    bg = colors.bg0,
                },
                TelescopePromptNormal = {
                    fg = colors.fg1,
                    bg = colors.bg1,
                },
                TelescopePromptPrefix = {
                    fg = colors.magenta,
                    bg = colors.bg1,
                },
                TelescopePromptTitle = {
                    fg = colors.bg1,
                    bg = colors.magenta,
                },
                TelescopeResultsNormal = {
                    bg = colors.bg0,
                },
                TelescopeResultsTitle = {
                    fg = colors.bg1,
                    bg = colors.magenta,
                },
                TelescopeSelectionCaret = {
                    fg = colors.cyan,
                    bg = colors.bg0,
                },
            },
        },
    }

    vim.cmd.colorscheme(M.theme)
end

--- Returns the colors that are used by the current theme.
---@return table: The color table used by the theme.
function M.colors()
    return require("nightfox.palette").load(M.theme)
end

return M
