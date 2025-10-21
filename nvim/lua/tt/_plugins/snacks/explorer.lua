local M = {}

---Source code adapted from: https://github.com/folke/snacks.nvim/discussions/1306#discussioncomment-12248922
---@type snacks.picker.Config
M.explorer = {
    -- Layout with removed input field
    layout = {
        preview = "main",
        layout = {
            backdrop = false,
            width = 40,
            min_width = 40,
            height = 0,
            position = "left",
            border = "none",
            box = "vertical",
            { win = "list", border = "none" },
        },
    },
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

        root:on("WinResized", function()
            update(preview_win)
        end)

        root:on("WinLeave", function()
            vim.schedule(function()
                if not picker:is_focused() then
                    picker.preview.win:close()
                end
            end)
        end)

        picker.preview.win = preview_win
        picker.main = preview_win.win
    end,
    on_close = function(picker)
        picker.preview.win:close()
    end,
    actions = {
        toggle_preview = function(picker)
            picker.preview.win:toggle()
        end,
        open = function(picker, ...)
            local explorer_actions = require "snacks.explorer.actions"
            picker.preview.win:close()
            explorer_actions.actions.confirm(picker, ...)
        end,
    },
    win = {
        list = {
            keys = {
                ["-"] = "explorer_up",
                ["o"] = "open",
                ["="] = "open",
                ["+"] = "open",
                ["O"] = "explorer_open",
                ["?"] = "toggle_help_list",
                ["<C-t>"] = "tab",
                ["<M-h>"] = false,
                ["/"] = false,
            },
        },
    },
}

return M
