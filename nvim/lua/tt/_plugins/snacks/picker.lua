local M = {}

---@type snacks.picker.layout.Config
local telecsope_layout = {
    reverse = true,
    layout = {
        box = "horizontal",
        backdrop = false,
        width = 0.8,
        height = 0.8,
        border = "none",
        {
            box = "vertical",
            { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
            {
                win = "input",
                height = 1,
                border = "rounded",
                title = "{title} {live} {flags}",
                title_pos = "center",
            },
        },
        {
            win = "preview",
            title = "{preview:Preview}",
            border = "rounded",
            width = 0.5,
            title_pos = "center",
        },
    },
}

---@type table<string, snacks.picker.layout.Config>
local layouts = {
    default = telecsope_layout,
    telescope = telecsope_layout,
    vertical = {
        reverse = true,
        layout = {
            backdrop = false,
            width = 0.7,
            min_width = 80,
            height = 0.8,
            min_height = 30,
            box = "vertical",
            border = "rounded",
            title = "{title} {live} {flags}",
            title_pos = "center",
            { win = "preview", title = "{preview}", height = 0.7, border = "bottom" },
            { win = "list", border = "none" },
            { win = "input", height = 1, border = "top" },
        },
    },
}

---@type table<string, false|string|fun(self: snacks.win)|snacks.win.Keys>
local common_keys = {
    ["<C-q>"] = { "close", mode = { "n", "i" } },
    ["<C-d>"] = { "preview_scroll_down", mode = { "n", "i" } },
    ["<C-u>"] = { "preview_scroll_up", mode = { "n", "i" } },
    ["<C-l>"] = { "preview_scroll_right", mode = { "n", "i" } },
    ["<C-h>"] = { "preview_scroll_left", mode = { "n", "i" } },
    ["<C-v>"] = { "edit_vsplit", mode = { "n", "i" } },
    ["<C-x>"] = { "edit_split", mode = { "n", "i" } },
    ["g?"] = { "toggle_help_list", mode = { "n", "i" } },
    ["?"] = { "toggle_preview", mode = { "n", "i" } },
}

---Recent picker filter to avoid excluding files that reside in the stdpath("data") directory
---@return fun(item: snacks.picker.finder.Item, filter:snacks.picker.Filter): boolean
local function get_recent_filter()
    local excluded_dirs = { vim.fn.stdpath "cache", vim.fn.stdpath "state" }

    return function(item, filter)
        -- Workaround hack to enable stdpath("data") entries as well,
        -- requires clearing out the Filter paths property
        if not filter.paths_cleared then
            filter.paths = {}
            ---@diagnostic disable-next-line: inject-field
            filter.paths_cleared = true
        end

        if not item or not item.file then
            return false
        end

        local excluded = vim.iter(excluded_dirs):any(function(dir)
            return vim.startswith(item.file, dir)
        end)

        return not excluded
    end
end

---@type snacks.picker.Config|{}
M.picker = {
    layouts = layouts,
    actions = {
        trouble_open = function(...)
            return require("trouble.sources.snacks").actions.trouble_open.action(...)
        end,
        cycle_preview = function(...)
            require("tt._plugins.snacks.actions").cycle_preview(...)
        end,
    },
    win = {
        input = {
            keys = vim.tbl_extend("force", common_keys, {
                ["<C-c>"] = { "trouble_open", mode = { "n", "i" } },
                ["<C-p>"] = { "cycle_preview", mode = { "n", "i" } },
            }),
        },
        list = {
            keys = common_keys,
        },
        preview = {
            wo = {
                wrap = false,
            },
        },
    },
    formatters = {
        file = {
            filename_first = true,
        },
    },
    sources = {
        recent = {
            filter = {
                filter = get_recent_filter(),
            },
        },
        files = {
            actions = {
                switch_grep = function(picker)
                    require("tt._plugins.snacks.actions").reopen_picker(
                        picker,
                        "grep",
                        { search = picker:filter().pattern }
                    )
                end,
            },
            win = {
                input = {
                    keys = {
                        ["<M-g>"] = { "switch_grep", mode = { "n", "i" } },
                    },
                },
            },
        },
        grep = {
            actions = {
                switch_files = function(picker)
                    require("tt._plugins.snacks.actions").reopen_picker(
                        picker,
                        "files",
                        { pattern = picker:filter().search }
                    )
                end,
            },
            win = {
                input = {
                    keys = {
                        ["<M-g>"] = { "switch_files", mode = { "n", "i" } },
                    },
                },
            },
            follow = true,
        },
        git_files = {
            actions = {
                switch_git_grep = function(picker)
                    require("tt._plugins.snacks.actions").reopen_picker(
                        picker,
                        "git_grep",
                        { search = picker:filter().pattern }
                    )
                end,
            },
            win = {
                input = {
                    keys = {
                        ["<M-g>"] = { "switch_git_grep", mode = { "n", "i" } },
                    },
                },
            },
        },
        git_grep = {
            actions = {
                switch_git_files = function(picker)
                    require("tt._plugins.snacks.actions").reopen_picker(
                        picker,
                        "git_files",
                        { pattern = picker:filter().search }
                    )
                end,
            },
            win = {
                input = {
                    keys = {
                        ["<M-g>"] = { "switch_git_files", mode = { "n", "i" } },
                    },
                },
            },
        },
        pickers = {
            layout = {
                preset = "vscode",
            },
        },
        buffers = {
            win = {
                input = {
                    keys = {
                        ["dd"] = { "bufdelete", mode = "n" },
                    },
                },
            },
        },
        explorer = require("tt._plugins.snacks.explorer").explorer,
        keymaps = {
            layout = {
                preset = "ivy",
                hidden = { "preview" },
            },
        },
        lines = {
            layout = {
                preset = "vertical",
                hidden = { "preview" },
                layout = { height = 0.85, width = 0.85 },
            },
        },
        help = { layout = { preset = "vertical" } },
        colorschemes = { layout = { preset = "vertical" } },
        notifications = { layout = { preset = "vertical" } },
    },
}

return M
