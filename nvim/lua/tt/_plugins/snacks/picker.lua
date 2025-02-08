local M = {}

local snack_picker_layouts = require "snacks.picker.config.layouts"

---@type table<string, snacks.picker.layout.Config>
M.layouts = {
    default = snack_picker_layouts.telescope,
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

---@type snacks.picker.Config|{}
M.picker = {
    layouts = M.layouts,
    win = {
        input = {
            keys = {
                ["<C-q>"] = { "close", mode = { "n", "i" } },
                ["<C-d>"] = { "preview_scroll_down", mode = { "n", "i" } },
                ["<C-u>"] = { "preview_scroll_up", mode = { "n", "i" } },
            },
        },
        list = {
            keys = {
                ["<C-q>"] = { "close", mode = { "n", "i" } },
                ["<C-d>"] = { "preview_scroll_down", mode = { "n", "i" } },
                ["<C-u>"] = { "preview_scroll_up", mode = { "n", "i" } },
            },
        },
    },
    sources = {
        pickers = {
            layout = {
                preset = "vscode",
            },
        },
        explorer = {
            layout = {
                preset = "sidebar",
                preview = "main",
                hidden = { "preview" },
            },
            win = {
                list = {
                    keys = {
                        ["-"] = "explorer_up",
                        ["o"] = "confirm",
                        ["="] = "confirm",
                        ["O"] = "explorer_open",
                        ["<M-h>"] = false,
                    },
                },
            },
        },
        keymaps = {
            layout = {
                preset = "ivy",
                hidden = { "preview" },
            },
        },
        help = {
            layout = {
                preset = "vertical",
            },
        },
        colorschemes = {
            layout = {
                preset = "vertical",
            },
        },
    },
}

return M
