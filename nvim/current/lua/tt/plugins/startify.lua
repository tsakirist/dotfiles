local M = {}

--- Directory where session files will be stored.
local sessions_path = vim.fn.stdpath "data" .. "/sessions/"

--- Create the `sessions` directory if it doesn't exists.
if vim.fn.isdirectory(sessions_path) == 0 then
    vim.fn.mkdir(sessions_path, "p")
    vim.notify(
        string.format("Created sessions directory: '%s'", sessions_path),
        vim.log.levels.INFO,
        { title = "Startify" }
    )
end

--- Expose the session_path to other modules.
---@return string sessions_path the directory where Startify stores saved sessions.
function M.get_sessions_path()
    return sessions_path
end

function M.setup()
    --- Do not show <empty> and <quit>
    vim.g.startify_enable_special = 0

    --- Show relative path for files
    vim.g.startify_relative_path = 0

    --- The number of files to show
    vim.g.startify_files_number = 8

    --- Update oldfiles on-the-fly to stay up-to-date
    vim.g.startify_update_oldfiles = 1

    --- Specify where to store sessions
    vim.g.startify_session_dir = M.get_sessions_path()

    --- Automatically update sessions
    vim.startify_session_persistence = 1

    --- Sort sessions by modification time
    vim.g.startify_session_sort = 1

    --- Number of sessions to show
    vim.g.startify_session_number = 5

    --- Specify the padding for the lists
    vim.g.startify_padding_left = 12

    --- Specify the lists that Startify should show
    vim.g.startify_lists = {
        { type = "commands", header = { "          Commands" } },
        { type = "files", header = { "          MRU" } },
        { type = "dir", header = { "          MRU " .. vim.fn.getcwd() } },
        { type = "sessions", header = { "          Sessions" } },
        { type = "bookmarks", header = { "          Bookmarks" } },
    }

    --- Specify the custom header to use
    local datetime = os.date "%A %d %B %Y, %T"
    local version = vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
    local plugins = require("lazy").stats().count

    local icons = require "tt.icons"

    local custom_header = {
        [[                                 __                 ]],
        [[    ___     ___    ___   __  __ /\_\    ___ ___     ]],
        [[   / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\   ]],
        [[  /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \  ]],
        [[  \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\ ]],
        [[   \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/ ]],
        [[                                                    ]],
        " " .. icons.misc.Bullets .. " Tryfon Tsakiris, tr.tsakiris@gmail.com",
        " " .. icons.misc.Calendar .. " " .. datetime,
        " " .. icons.misc.Branch .. " Neovim Version: " .. version,
        " " .. icons.misc.Plug .. " Plugins: " .. plugins,
    }

    vim.g.startify_custom_header = vim.fn["startify#center"](custom_header)

    --- Add custom commands
    vim.g.startify_commands = {
        { e = { icons.document.Document .. " New file", ":enew" } },
        { f = { icons.document.DocumentSearch .. " Find Files", ":Telescope find_files" } },
        { g = { icons.document.DocumentWord .. " Grep Word", ":Telescope live_grep_args" } },
        { r = { icons.document.DoubleDocument .. " Recent Files", ":Telescope oldfiles" } },
        { h = { icons.misc.Bulb .. " Help", ":Telescope help_tags" } },
        { s = { icons.misc.Storage .. " Sessions", ":lua require'tt.plugins.telescope'.find_sessions()" } },
    }

    local config_path = vim.fn.stdpath "config"

    --- Add custom bookmarks
    vim.g.startify_bookmarks = {
        { v = config_path .. "/init.lua" },
        { p = config_path .. "/lua/tt/plugins.lua" },
        { z = "~/.zshrc" },
        { a = "~/.zsh_aliases" },
    }

    --- Make Startify use WebDevIcons instead
    vim.cmd [[
        function! StartifyEntryFormat() abort
            return 'v:lua.WebDevIcons(absolute_path) . " " . entry_path'
        endfunction
    ]]

    vim.cmd.highlight { "link StartifyHeader Statement", bang = true }
end

return M
