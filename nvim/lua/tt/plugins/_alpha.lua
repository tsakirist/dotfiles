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
    [[   ﯟ Tryfon Tsakiris, tr.tsakiris@gmail.com         ]],
    [[    ]] .. datetime,
    [[    Neovim Version: ]] .. version,
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
    startify.button("q", "  Quit", ":qa<CR>"),
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

-- Set header
-- dashboard.section.header.val = {
--     "                                                     ",
--     "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
--     "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
--     "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
--     "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
--     "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
--     "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
--     "                                                     ",
-- }

-- -- Set menu
-- dashboard.section.buttons.val = {
--     dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
--     dashboard.button("f", "  > Find file", ":cd $HOME/Workspace | Telescope find_files<CR>"),
--     dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
--     dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
--     dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
-- }

-- -- Plugins
-- -- local total_plugins = #vim.tbl_keys(packer_plugins)
-- -- local loaded_plugins = #vim.fn.globpath(vim.fn.stdpath "data" .. "/site/pack/packer/start", "*", 0, 1)
-- -- local plugins_text = "Total plugins: " .. total_plugins .. "\nLoaded plugins: " .. loaded_plugins

-- -- Date
-- -- local datetime = os.date "%d-%m-%Y  %H:%M:%S"
-- --
-- local function get_footer()
--     local total_plugins = #vim.tbl_keys(packer_plugins)
--     local loaded_plugins = #vim.fn.globpath(vim.fn.stdpath "data" .. "/site/pack/packer/start", "*", 0, 1)
--     local datetime = os.date "%A %d %B %Y, %T"

--     local footer = {
--         "Plugins (L/T): (" .. loaded_plugins .. "/" .. total_plugins .. ")",
--         "",
--         datetime,
--     }

--     return quote
-- end

-- -- Set footer
-- -- local fortune = require "alpha.fortune"
-- -- dashboard.section.footer.val = fortune()
-- dashboard.section.footer.val = get_footer()

-- -- Send config to alpha
-- alpha.setup(dashboard.opts)
