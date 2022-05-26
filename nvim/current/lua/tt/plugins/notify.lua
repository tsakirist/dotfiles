local M = {}

function M.setup()
    require("notify").setup {
        background_colour = "Normal",
        render = "default",
        stages = "fade_in_slide_out",
        level = "info",
        minimum_width = 50,
        timeout = 3000,
        fps = 30,
        icons = {
            DEBUG = "",
            ERROR = "",
            INFO = "",
            TRACE = "✎",
            WARN = "",
        },
        on_open = function(win)
            -- Disable window focus by user actions in notifications
            vim.api.nvim_win_set_config(win, { focusable = false })
        end,
    }

    --- Set custom highlight groups for notifications
    local colors = require("tt.plugins.nightfox").colors()
    vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "NotifyINFOTitle", { fg = colors.blue })

    --- Set nvim-notify as the default handler for notifications
    vim.notify = require "notify"
end

local utils = require "tt.utils"
utils.map("n", "<leader>nd", require("notify").dismiss)

return M
