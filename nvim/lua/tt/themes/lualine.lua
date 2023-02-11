local M = {}

function M.setup()
    local icons = require "tt.icons"

    ---@diagnostic disable-next-line: unused-local
    local normal_theme = {
        component_separators = {
            left = icons.misc.RightUnfilledArrow,
            right = icons.misc.LeftUnfilledArrow,
        },
        section_separators = {
            left = icons.misc.RightFilledArrow,
            right = icons.misc.LeftFilledArrow,
        },
        lualine_a = {
            padding = 1,
            separator = {
                right = icons.misc.VerticalShadowedBox,
            },
        },
        lualine_z = {
            padding = nil,
            separator = nil,
        },
    }

    local bubble_theme = {
        component_separators = "",
        section_separators = {
            left = icons.misc.RightHalfCircle,
            right = icons.misc.LeftHalfCircle,
        },
        lualine_a = {
            padding = {
                right = 2,
            },
            separator = {
                left = icons.misc.LeftHalfCircle,
            },
        },
        lualine_z = {
            padding = 1,
            seperator = {
                right = icons.misc.RightHalfCircle,
            },
        },
    }

    -- Custom lualine options for the different sections
    local custom_theme = bubble_theme

    require("lualine").setup {
        options = {
            theme = "auto",
            component_separators = custom_theme.component_separators,
            section_separators = custom_theme.section_separators,
            icons_enabled = true,
            disabled_filetypes = {
                "help",
                "startify",
                "gitcommit",
                "lazy",
            },
            always_divide_middle = true,
            globalstatus = true,
        },
        extensions = {
            "neo-tree",
            "toggleterm",
        },
        tabline = {
            lualine_a = {
                {
                    "buffers",
                    mode = 4, -- Show buffer name and number
                    separator = {
                        left = icons.misc.LeftHalfCircle,
                        right = icons.misc.RightHalfCircle,
                    },
                    padding = {
                        right = 2,
                    },
                    symbols = {
                        alternate_file = "",
                    },
                },
            },
            lualine_z = {
                {
                    "tabs",
                    cond = function()
                        return vim.fn.tabpagenr "$" > 1
                    end,
                },
            },
        },
        sections = {
            lualine_a = {
                {
                    "mode",
                    padding = custom_theme.lualine_a.padding,
                    separator = custom_theme.lualine_a.separator,
                    icon = icons.misc.Owl,
                },
            },
            lualine_b = {
                "branch",
                "diff",
                {
                    "diagnostics",
                    symbols = {
                        error = icons.diagnostics.Error,
                        hint = icons.diagnostics.Hint,
                        info = icons.diagnostics.Info,
                        warn = icons.diagnostics.Warn,
                    },
                },
            },
            lualine_c = {
                {
                    "searchcount",
                    color = "LualineSearchCount",
                    icon = icons.misc.Search,
                    on_click = function(number_of_clicks, mouse_button, modifier)
                        --- Left click goes to next search hit and right click to previous
                        if mouse_button == "l" then
                            vim.fn.feedkeys "n"
                        elseif mouse_button == "r" then
                            vim.fn.feedkeys "N"
                        end
                    end,
                },
            },
            lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_y = { "progress" },
            lualine_z = {
                {
                    "location",
                    separator = custom_theme.lualine_z.separator,
                    padding = custom_theme.lualine_z.padding,
                },
            },
        },
    }
end

return M
