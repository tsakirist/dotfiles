local M = {}

---@type snacks.picker.Config|{}
M.picker = {
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
