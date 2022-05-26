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

    --- Set nvim-notify as the default handler for notifications
    vim.notify = require "notify"
end

local utils = require "tt.utils"
utils.map("n", "<leader>nd", require("notify").dismiss)

return M
