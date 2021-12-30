local alpha = require "alpha"
local startify = require "alpha.themes.startify"

-- Stuff to put on header
local datetime = os.date "%A %d %B %Y, %T"
local version = vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch

startify.section.header.opts.position = "center"
startify.section.header.val = {
    [[                                  __                ]],
    [[     ___     ___    ___   __  __ /\_\    ___ ___    ]],
    [[    / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
    [[   /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
    [[   \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
    [[    \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
    [[                                                    ]],
    [[     Tryfon Tsakiris, tr.tsakiris@gmail.com         ]],
    "     " .. datetime,
    "     Neovim Version: " .. version,
}

startify.section.top_buttons.val = {
    startify.button("e", "  New file", ":enew<CR>"),
    startify.button("f", "  Find Files", ":Telescope find_files<CR>"),
    startify.button("w", "  Find Word", ":Telescope live_grep<CR>"),
    startify.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
    startify.button("h", "  Help", ":Telescope help_tags<CR>"),
}

local path = vim.fn.stdpath "config"

startify.section.bottom_buttons.val = {
    startify.file_button(path .. "/lua/tt/plugins.lua", "p"),
    startify.file_button(path .. "/init.lua", "i"),
    { type = "padding", val = 2 },
    startify.button("q", "  Quit", ":qa<CR>"),
}

startify.opts = {
    layout = {
        { type = "padding", val = 2 },
        startify.section.header,
        { type = "padding", val = 2 },
        startify.section.top_buttons,
        startify.section.mru,
        startify.section.mru_cwd,
        { type = "padding", val = 2 },
        startify.section.bottom_buttons,
    },
    opts = {
        margin = 10,
    },
}

alpha.setup(require("alpha.themes.startify").opts)
