-- Do not show <empty> and <quit>
vim.g.startify_enable_special = 0

-- Show relative path for files
vim.g.startify_relative_path = 0

-- The number of files to show
vim.g.startify_files_number = 6

-- Update oldfiles on-the-fly to stay up-to-date
vim.g.startify_update_oldfiles = 1

-- Specify where to store sessions
vim.g.startify_session_dir = vim.fn.stdpath "data" .. "/sessions/"

-- Automatically update sessions
vim.startify_session_persistence = 1

-- Sort sessions by modification time
vim.g.startify_session_sort = 1

-- Number of sessions to show
vim.g.startify_session_number = 5

-- Specify the padding for the lists
vim.g.startify_padding_left = 12

-- Specify the lists that Startify should show
vim.g.startify_lists = {
    { type = "commands", header = { "          Commands" } },
    { type = "files", header = { "          MRU" } },
    { type = "dir", header = { "          MRU " .. vim.fn.getcwd() } },
    { type = "sessions", header = { "          Sessions" } },
    { type = "bookmarks", header = { "          Bookmarks" } },
}

-- Specify the custom header to use
local datetime = os.date "%A %d %B %Y, %T"
local version = vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch

local custom_header = {
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

vim.g.startify_custom_header = vim.fn["startify#center"](custom_header)

-- Add custom commands
vim.g.startify_commands = {
    { e = { "  New file", ":enew" } },
    { f = { "  Find Files", ":Telescope find_files" } },
    { w = { "  Find Word", ":Telescope live_grep" } },
    { r = { "  Recent Files", ":Telescope oldfiles" } },
    { h = { "  Help", ":Telescope help_tags" } },
    -- { s = { "  Sessions", ":Telescope sessions<CR>" } },
}

local config_path = vim.fn.stdpath "config"

-- Add custom bookmarks
vim.g.startify_bookmarks = {
    { v = config_path .. "/init.lua" },
    { p = config_path .. "/lua/tt/plugins.lua" },
    { z = "~/.zshrc" },
    { a = "~/.zsh_aliases" },
}

-- Setup the required function so that Startify can use WebDevIcons
vim.cmd [[
    function! StartifyEntryFormat() abort
        return 'v:lua.WebDevIcons(absolute_path) . " " . entry_path'
    endfunction
]]
