local icons = require "tt.icons"
local utils = require "tt.utils"

local M = {}

---Returns items to be used in the Dashboard.
---A function shall be returned when content needs to be dynamically updated.
local function get_dashboard_items()
    local header = table.concat({
        [[                                                                    ]],
        [[      ████ ██████           █████      ██                TT   ]],
        [[     ███████████             █████                             ]],
        [[     █████████ ███████████████████ ███   ███████████   ]],
        [[    █████████  ███    █████████████ █████ ██████████████   ]],
        [[   █████████ ██████████ █████████ █████ █████ ████ █████   ]],
        [[ ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
        [[██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
        [[                                                                      ]],
    }, "\n")

    local function generate_info()
        local datetime = os.date "%A %d %B %Y, %T"
        local version = table.concat({
            vim.version().major,
            vim.version().minor,
            vim.version().patch,
        }, ".")
        local info_items = {
            icons.misc.Github .. " Tryfon Tsakiris, tr.tsakiris@gmail.com",
            icons.misc.Calendar .. " " .. datetime,
            icons.misc.GitCompare .. " Neovim Version: " .. version,
        }

        local max_item_length = math.max(unpack(vim.tbl_map(function(info_item)
            return #info_item
        end, info_items)))

        info_items = vim.tbl_map(function(info_item)
            return utils.pad(info_item, { length = max_item_length - #info_item })
        end, info_items)

        return table.concat(info_items, "\n")
    end

    local info = generate_info()

    local plugins_file = utils.join_paths(vim.fn.stdpath "config", "lua", "tt", "plugins.lua")

    local function startup()
        local lazy_stats = require("lazy.stats").stats()
        local ms = (math.floor(lazy_stats.startuptime * 100 + 0.5) / 100)
        return {
            align = "center",
            text = {
                { icons.misc.Thunder .. " Neovim loaded ", hl = "special" },
                { lazy_stats.loaded .. "/" .. lazy_stats.count, hl = "SnacksDashboardStartupMetrics" },
                { " plugins in ", hl = "special" },
                { ms .. "ms", hl = "SnacksDashboardStartupMetrics" },
            },
        }
    end

    return header, info, plugins_file, startup
end

local header, info, plugins_file, startup = get_dashboard_items()

---@type snacks.dashboard.Config|{}
M.dashboard = {
    enabled = true,
    width = 80,
    formats = {
        key = function(item)
            return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
        end,
    },
    preset = {
        header = header,
        keys = {
            -- stylua: ignore start
            { icon = icons.document.Document, key = "e", desc = "New file", action = ":ene | startinsert" },
            { icon = icons.misc.Search, key = "f", desc = "Find files", action = "<leader>ff" },
            { icon = icons.misc.TextSearch, key = "g", desc = "Find text", action = "<leader>fg" },
            { icon = icons.document.FileUndo, key = "r", desc = "Recent files", action = "<leader>fo" },
            { icon = icons.document.Documents, key = "F", desc = "Find in git files", action = "<leader>fF"},
            { icon = icons.document.DocumentSearch, key = "G", desc = "Grep in git files", action = "<leader>fG"},
            { icon = icons.document.FileCog, key = "v", desc = "Find config file", action = "<leader>fv"},
            { icon = icons.misc.Database, key = "s", desc = "Find sessions", action = "<leader>fS" },
            { icon = icons.misc.Restore, key = "S", desc = "Restore last session", action = ":SLast" },
            { icon = icons.misc.Sleep, key = "z", desc = "Lazy", action = "<leader>lz", enabled = package.loaded.lazy ~= nil },
            { icon = icons.misc.Quit, key = "q", desc = "Quit", action = ":qa" },
            -- stylua: ignore end
        },
    },
    sections = {
        { section = "header", align = "center", padding = 1 },
        { text = { { info, hl = "SnacksDashboardInfo" } }, align = "center", padding = 1 },
        { title = "Commands", padding = 1 },
        { section = "keys", padding = 2 },
        { title = "MRU", padding = 1 },
        { section = "recent_files", limit = 5, padding = 1 },
        { title = "MRU ", file = vim.fn.fnamemodify(".", ":~"), padding = 1 },
        { section = "recent_files", cwd = true, limit = 5, padding = 2 },
        { title = "Bookmarks", padding = 1 },
        {
            file = vim.fn.fnamemodify(plugins_file, ":~"),
            icon = "file",
            key = "p",
            action = ":e " .. plugins_file,
            padding = 2,
        },
        { startup },
    },
}

return M
