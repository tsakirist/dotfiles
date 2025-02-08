local M = {}

---@type table<string, snacks.picker.layout.Config>
M.layouts = {
    default = {
        reverse = true,
        layout = {
            box = "horizontal",
            width = 0.8,
            min_width = 120,
            height = 0.8,
            {
                box = "vertical",
                border = "rounded",
                title = "{title} {live} {flags}",
                { win = "list", border = "bottom" },
                { win = "input", border = "none", height = 1 },
            },
            { win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
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
                preview = {
                    main = true,
                    enabled = false,
                },
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
                preview = false,
            },
        },
    },
}

return M
