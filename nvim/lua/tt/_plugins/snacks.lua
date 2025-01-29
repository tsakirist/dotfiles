local M = {}

local utils = require "tt.utils"
local icons = require "tt.icons"

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

function M.setup()
    local header, info, plugins_file, startup = get_dashboard_items()

    require("snacks").setup {
        bigfile = {
            enabled = true,
        },
        quickfile = {
            enabled = true,
        },
        notifier = {
            enabled = true,
        },
        scratch = {
            template = "",
            win_by_ft = {
                lua = {
                    keys = {
                        ["source"] = {
                            "<C-s>",
                            mode = { "n", "x" },
                            function(self)
                                local name = "scratch." .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
                                Snacks.debug.run { buf = self.buf, name = name }
                            end,
                            desc = "Execute buffer",
                        },
                    },
                },
            },
        },
        zen = {
            win = {
                width = 0.9,
                keys = {
                    q = "close",
                },
            },
        },
        dashboard = {
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
                    { icon = icons.misc.Notes, key = "g", desc = "Find text", action = "<leader>fg" },
                    { icon = icons.document.Documents, key = "r", desc = "Recent files", action = "<leader>fo" },
                    { icon = icons.misc.Settings, key = "F", desc = "Find config file", action = "<leader>fv"},
                    { icon = icons.misc.Settings, key = "G", desc = "Find config text", action = "<leader>gv"},
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
        },
        styles = {
            notification = {
                wo = {
                    wrap = true,
                },
                relative = "editor",
            },
            notification_history = {
                width = 0.75,
                height = 0.75,
                relative = "editor",
            },
            scratch = {
                width = 0.70,
                height = 0.65,
                relative = "editor",
            },
        },
    }

    utils.map("n", { "<leader>lg", "<leader>lt" }, function()
        Snacks.lazygit()
    end, { desc = "Open Lazygit" })

    utils.map("n", "<leader>nh", function()
        Snacks.notifier.show_history()
    end, { desc = "Show notification history" })

    utils.map("n", "<leader>nd", function()
        Snacks.notifier.hide()
    end, { desc = "Hide all notifications" })

    utils.map("n", "<leader>bd", Snacks.bufdelete.delete, { desc = "Delete current buffer" })

    utils.map("n", "<leader>bD", function()
        Snacks.bufdelete.delete { force = true }
    end, { desc = "Force delete current buffer" })

    utils.map("n", "<leader>so", Snacks.scratch.open, { desc = "Open scratch buffer" })

    utils.map("n", "<F1>", Snacks.zen.zen, { desc = "Toggle Zen mode" })

    Snacks.toggle.dim():map("<leader>sd", { desc = "Toggle dim mode" })

    vim.api.nvim_create_user_command("Rename", Snacks.rename.rename_file, { desc = "Rename current file" })
end

return M
