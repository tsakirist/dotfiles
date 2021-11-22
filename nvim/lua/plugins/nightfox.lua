require("nightfox").setup {
    fox = "nordfox", -- Which fox style should be applied
    transparent = false, -- Disable setting the background color
    alt_nc = false, -- Non current window bg to alt color see `hl-NormalNC`
    terminal_colors = true, -- Configure the colors used when opening :terminal
    styles = {
        comments = "italic",
        functions = "NONE",
        keywords = "NONE",
        strings = "NONE",
        variables = "NONE",
    },
    inverse = {
        match_paren = false, -- Enable/Disable inverse highlighting for match parens
        visual = false, -- Enable/Disable inverse highlighting for visual selection
        search = false, -- Enable/Disable inverse highlights for search highlights
    },
    colors = {}, -- Override default colors
    hlgroups = {}, -- Override highlight groups
}

-- Load the configuration set above and apply the colorscheme
require("nightfox").load()
