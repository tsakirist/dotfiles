--- Defines which kind source to use
local kind_source = _G.IsWSL() and "default" or "vscode"

local kind = {
    default = {
        Class = "󰠱  ",
        Color = "󰏘  ",
        Constant = "󰏿  ",
        Constructor = "  ",
        Enum = "  ",
        EnumMember = "  ",
        Event = "  ",
        Field = "󰜢  ",
        File = "󰈙  ",
        Folder = "󰉋  ",
        Function = "󰊕  ",
        Interface = "  ",
        Keyword = "󰌋  ",
        Method = "󰆧  ",
        Module = "  ",
        Operator = "󰆕  ",
        Property = "󰜢  ",
        Reference = "󰈇  ",
        Snippet = "  ",
        Struct = "󰙅  ",
        Text = "󰉿  ",
        TypeParameter = "  ",
        Unit = "󰑭  ",
        Value = "󰎠  ",
        Variable = "󰀫  ",
    },
    -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-codicons-to-the-menu
    vscode = {
        Class = "  ",
        Color = "  ",
        Constant = "  ",
        Constructor = "  ",
        Enum = "  ",
        EnumMember = "  ",
        Event = "  ",
        Field = "  ",
        File = "  ",
        Folder = "  ",
        Function = "  ",
        Interface = "  ",
        Keyword = "  ",
        Method = "  ",
        Module = "  ",
        Operator = "  ",
        Property = "  ",
        Reference = "  ",
        Snippet = "",
        Struct = "  ",
        Text = "  ",
        TypeParameter = "  ",
        Unit = "  ",
        Value = "  ",
        Variable = "  ",
    },
}

local kind_trimmed = (function()
    local result = {}
    for key, value in pairs(kind[kind_source]) do
        result[key] = require("tt.utils").trim(value)
    end
    return result
end)()

local diagnostics = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
}

local git = {
    Added = " ",
    Modified = " ",
    Removed = " ",
}

local misc = {
    AlignRight = "",
    ArrowColappsed = "",
    ArrowCollapsedSmall = "",
    ArrowExpanded = "",
    ArrowExpandedSmall = "",
    ArrowRight = "➜",
    ArrowSouthWest = "󰁂",
    BigCircle = "",
    BigUnfilledCircle = "",
    Branch = "",
    Bug = "",
    BugColored = "🐞",
    Bulb = "󰌵",
    BulbColored = "💡",
    Bullets = "ﯟ",
    Calendar = "",
    CallIncoming = "",
    CallOutgoing = "",
    CheckMark = "✓",
    ChevronRight = ">",
    Circle = "●",
    CodeInspect = "",
    CurtainsClosed = "󱡇",
    CurtainsOpen = "󱡆",
    Database = "󰆼",
    Edit = "",
    Ellipsis = "…",
    LeftFilledArrow = "",
    LeftHalfCircle = "",
    LeftUnfilledArrow = "",
    Owl = "",
    Plug = "",
    RightFilledArrow = "",
    RightHalfCircle = "",
    RightUnfilledArrow = "",
    Search = "",
    Selection = "",
    Star = "*",
    VerticalShadowedBox = " ",
    XMark = "✗",
}

local document = {
    Document = "󰈔",
    DocumentSearch = "󰱼",
    DocumentWord = "󰈙",
    Documents = "󰈢",
    FileEye = "󰷊",
    FolderClosed = "",
    FolderConfig = "",
    FolderEmpty = "󰉖",
    FolderOpen = "",
}

return {
    kind = kind[kind_source],
    breadcrumps = kind_trimmed,
    diagnostics = diagnostics,
    document = document,
    git = git,
    misc = misc,
}
