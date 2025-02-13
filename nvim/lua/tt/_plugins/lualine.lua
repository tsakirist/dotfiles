local M = {}

function M.setup()
    local grapple = require "grapple"
    local noice = require "noice"
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
            separator = {
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
                "gitcommit",
            },
            always_divide_middle = true,
            globalstatus = true,
        },
        extensions = {
            "neo-tree",
            "toggleterm",
            "lazy",
        },
        tabline = {
            lualine_a = {
                {
                    "buffers",
                    mode = 4, -- Show buffer name and number
                    show_modified_status = true,
                    max_length = vim.o.columns,
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
            lualine_b = { "branch" },
            lualine_c = {
                {
                    grapple.statusline,
                    cond = grapple.exists,
                },
                {
                    "diagnostics",
                    symbols = {
                        error = icons.diagnostics.Error,
                        hint = icons.diagnostics.Hint,
                        info = icons.diagnostics.Info,
                        warn = icons.diagnostics.Warn,
                    },
                },
                {
                    "filetype",
                    icon_only = true,
                    separator = "",
                    padding = { left = 1, right = 0 },
                },
                {
                    "filename",
                    padding = { left = 0 },
                },
            },
            lualine_x = {
                -- Show macro recordings
                {
                    ---@diagnostic disable-next-line: undefined-field
                    noice.api.status.mode.get,
                    ---@diagnostic disable-next-line: undefined-field
                    cond = noice.api.status.mode.has,
                    color = "@keyword",
                },
                {
                    "diff",
                    symbols = {
                        added = icons.git.Added,
                        modified = icons.git.Modified,
                        removed = icons.git.Removed,
                    },
                },
                "encoding",
                "fileformat",
            },
            lualine_y = {
                {
                    "selectioncount",
                    icon = { icons.misc.Selection, align = "right" },
                },
                "progress",
            },
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
