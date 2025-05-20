local M = {}

M.theme = "carbonfox"

function M.setup()
    local colors = M.colors()
    local spec = M.spec()

    local Color = require "nightfox.lib.color"
    local utils = require "tt.utils"

    require("nightfox").setup {
        options = {
            compile_path = utils.join_paths(vim.fn.stdpath "cache", "nightfox"), -- Compile path directory
            compile_file_suffix = "_compiled", -- The suffix compiled file will have
            dim_inactive = false, -- Dim inactive windows
            terminal_colors = true, -- Configure the colors used when opening :terminal
            transparent = false, -- Disable setting the background color
            styles = {
                comments = "italic",
                conditionals = "NONE",
                constants = "bold",
                functions = "bold",
                keywords = "NONE",
                numbers = "NONE",
                operators = "NONE",
                strings = "NONE",
                types = "NONE",
                variables = "NONE",
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
                diag = {
                    hint = colors.cyan.base,
                },
                diag_bg = {
                    hint = Color(spec.bg1):blend(Color(colors.cyan.base), 0.2):to_css(),
                },
            },
        },
        groups = {
            all = {
                BarbecueSeparator = { fg = colors.white },
                BlinkCmpKind = { bg = colors.bg0 },
                BlinkCmpLabelMatch = { style = "bold" },
                BlinkCmpMenu = { bg = colors.bg0 },
                BlinkCmpMenuBorder = { fg = colors.bg0, bg = colors.bg0 },
                BlinkCmpMenuSelection = { fg = colors.bg0, bg = colors.blue.bright },
                BlinkCmpSource = { link = "Comment" },
                GitSignsAddInline = { bg = Color(spec.bg1):blend(Color(colors.green.dim), 0.55):to_css() },
                GitSignsChangeInline = { bg = Color(spec.bg1):blend(Color(colors.yellow.dim), 0.55):to_css() },
                GitSignsDeleteInline = { bg = Color(spec.bg1):blend(Color(colors.red.dim), 0.55):to_css() },
                SnacksDashboardInfo = { fg = colors.white, style = "bold,italic" },
                SnacksDashboardStartupMetrics = { fg = colors.white, style = "bold" },
                SnacksPickerDir = { link = "Comment" },
                SnacksPickerInput = { link = "SnacksPickerList" },
                SnacksPickerList = { fg = colors.white, bg = colors.bg1 },
                SnacksPickerPreview = { link = "SnacksPickerList" },
                SnacksPickerTitle = { fg = spec.bg4 },
                SniprunFloatingWinErr = { link = "Error" },
                SniprunFloatingWinOk = { fg = colors.cyan },
            },
            carbonfox = {
                ActionPreviewTitle = { link = "Title" },
                CodeActionNumber = { link = "Keyword" },
                CodeActionText = { link = "Normal" },
                DressingBorder = { fg = colors.blue, bg = colors.bg1 },
                LspSignatureActiveParameter = { bg = "#20253a", fg = "none", style = "bold" },
                MatchParen = { fg = colors.red, style = "bold,italic" },
                NoiceVirtualText = { link = "DiagnosticVirtualTextWarn" },
                SagaBeacon = { fg = colors.cyan },
                SagaBorder = { link = "TelescopeBorder" },
                SagaNormal = { link = "TelescopeNormal" },
                TitleIcon = { link = "Exception" },
                TitleString = { link = "Title" },
                GlanceWinBarFilename = { fg = colors.magenta, style = "bold" },
                GlanceWinBarFilepath = { fg = colors.fg2, style = "italic" },
                GlanceWinBarTitle = { fg = colors.fg2 },
                GlanceListFilename = { fg = colors.blue },
                GlanceListFilepath = { link = "GlanceWinbarTitle" },
                GlanceListCount = { link = "GlanceWinBarTitle" },
            },
            nordfox = {
                DressingBorder = { fg = colors.blue, bg = colors.bg1 },
                DressingInput = { fg = colors.magenta, bg = colors.bg1 },
                MatchParen = { fg = colors.orange, style = "bold,italic" },
                NavicIconsClass = { fg = colors.yellow, bg = colors.bg0 },
                NavicIconsConstructor = { fg = colors.yellow.dim, bg = colors.bg0 },
                NavicIconsEnum = { fg = colors.cyan, bg = colors.bg0 },
                NavicIconsEnumMember = { fg = colors.cyan.bright, bg = colors.bg0 },
                NavicIconsFunction = { fg = colors.magenta, bg = colors.bg0 },
                NavicIconsInterface = { fg = colors.yellow.bright, bg = colors.bg0 },
                NavicIconsKey = { fg = colors.green, bg = colors.bg0 },
                NavicIconsMethod = { fg = colors.magenta, bg = colors.bg0 },
                NavicIconsNamespace = { fg = colors.white, bg = colors.bg0 },
                NavicIconsProperty = { fg = colors.blue, bg = colors.bg0 },
                NavicIconsVariable = { fg = colors.cyan, bg = colors.bg0 },
                NavicIconsStruct = { fg = colors.yellow, bg = colors.bg0 },
                TelescopeBorder = { fg = colors.bg0, bg = colors.bg0 },
                TelescopeMatching = { fg = colors.magenta },
                TelescopePreviewNormal = { bg = colors.bg0 },
                TelescopePreviewTitle = { fg = colors.bg1, bg = colors.cyan },
                TelescopePromptBorder = { fg = colors.bg0, bg = colors.bg0 },
                TelescopePromptNormal = { fg = colors.fg1, bg = colors.bg1 },
                TelescopePromptPrefix = { fg = colors.magenta, bg = colors.bg1 },
                TelescopePromptTitle = { fg = colors.bg1, bg = colors.magenta },
                TelescopeResultsNormal = { bg = colors.bg0 },
                TelescopeResultsTitle = { fg = colors.bg1, bg = colors.magenta },
                TelescopeSelectionCaret = { fg = colors.cyan, bg = colors.bg0 },
            },
        },
    }

    vim.cmd.colorscheme(M.theme)
end

---Returns the color palette that is used by the passed theme or the currently active theme.
---@param theme? string: an optional theme to get the palette from.
---@return table: The color table used by the theme.
function M.colors(theme)
    return require("nightfox.palette").load(theme or M.theme)
end

---Returns the specs that are used by the passed theme or the currently active theme.
---@param theme? string: an optional theme to get the spec from.
---@return table: the specs table used by the theme.
function M.spec(theme)
    return require("nightfox.spec").load(theme or M.theme)
end

return M
