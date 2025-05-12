local M = {}

---Source code adapted from: https://github.com/folke/snacks.nvim/discussions/1306#discussioncomment-12248922
---@type snacks.picker.Config
M.explorer = {
    on_show = function(picker)
        local window_gap = 1

        local root = picker.layout.root

        ---@param win snacks.win
        local update = function(win)
            win.opts.row = vim.api.nvim_win_get_position(root.win)[1]
            win.opts.col = vim.api.nvim_win_get_width(root.win) + window_gap
            win.opts.height = 0.85
            win.opts.width = 0.5
            win:update()
        end

        local preview_win = Snacks.win.new {
            relative = "editor",
            external = false,
            focusable = false,
            border = "rounded",
            backdrop = false,
            show = false,
            bo = {
                filetype = "snacks_float_preview",
                buftype = "nofile",
                buflisted = false,
                swapfile = false,
                undofile = false,
            },
            on_win = function(win)
                update(win)
                picker:show_preview()
            end,
        }

        picker.preview.win = preview_win

        root:on("WinResized", function()
            update(preview_win)
        end)
    end,
    actions = {
        toggle_preview = function(picker)
            picker.preview.win:toggle()
        end,
    },
    win = {
        list = {
            keys = {
                ["-"] = "explorer_up",
                ["o"] = "confirm",
                ["="] = "confirm",
                ["+"] = "confirm",
                ["O"] = "explorer_open",
                ["?"] = "toggle_help_list",
                ["<C-t>"] = "tab",
                ["<M-h>"] = false,
            },
        },
    },
}

return M
