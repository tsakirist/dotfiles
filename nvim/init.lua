--[[

    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝

    " -------------------------
    Author: Tryfon Tsakiris
    Email: tr.tsakiris@gmail.com
    Url: https://raw.githubusercontent.com/tsakirist/dotfiles/master/nvim
    ------------------------- "

--]]

-- Import Lua modules

require "plugins"
require "settings"
require "autocommands"
require "abbreviations"
require "mappings"

-- Setup colorscheme
-- vim.cmd("colorscheme nordfox")
vim.cmd "colorscheme darcula"
