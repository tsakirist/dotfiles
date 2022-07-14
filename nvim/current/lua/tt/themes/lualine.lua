local M = {}

function M.setup()
    -- Module that shows the current cursor context
    local gps = require "nvim-gps"
    local icons = require "tt.icons"

    -- Get the colors that are used by the theme
    local colors = require("tt.plugins.nightfox").colors()

    require("lualine").setup {
        options = {
            icons_enabled = true,
            theme = "nightfox",
            component_separators = {
                left = icons.misc.RightUnfilledArrow,
                right = icons.misc.LeftUnfilledArrow,
            },
            section_separators = {
                left = icons.misc.RightFilledArrow,
                right = icons.misc.LeftFilledArrow,
            },
            disabled_filetypes = {},
            always_divide_middle = true,
            globalstatus = true,
        },
        sections = {
            lualine_a = {
                {
                    "mode",
                    padding = 1,
                    separator = { right = icons.misc.VerticalShadowedBox },
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
                    gps.get_location,
                    cond = gps.is_available,
                    color = { fg = colors.magenta },
                },
            },
            lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
    }
end

return M
