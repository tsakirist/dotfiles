local M = {}

function M.setup()
    ---@type Options
    require("rose-pine").setup {
        variant = "main",
        dark_variant = "main",
        dim_inactive_windows = true,
        styles = {
            bold = true,
            italic = false,
            transparency = false,
        },
        highlight_groups = {
            TelescopeBorder = { fg = "overlay", bg = "overlay" },
            TelescopeNormal = { fg = "text", bg = "overlay" },
            TelescopeTitle = { fg = "base", bg = "rose" },
            TelescopePreviewTitle = { link = "TelescopeTitle" },
            TelescopePromptTitle = { fg = "base", bg = "foam" },
            TelescopePromptNormal = { fg = "text", bg = "surface" },
            TelescopePromptBorder = { fg = "surface", bg = "surface" },
            TelescopePromptPrefix = { fg = "foam", bg = "surface" },
            TelescopeSelection = { bg = "highlight_med" },
            CmpWindowBorder = { fg = "base", bg = "base" },
            CmpWindowCursorLine = { fg = "base", bg = "foam" },
            CmpItemAbbrMatch = { fg = "foam" },
            CmpItemAbbr = { fg = "text" },
            StartifyFile = { fg = "foam" },
            StartifyHeader = { fg = "rose" },
            StartifyPath = { fg = "pine" },
        },
    }
end

return M
