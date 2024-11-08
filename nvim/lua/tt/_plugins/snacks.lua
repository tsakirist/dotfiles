local M = {}

function M.setup()
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
        statuscolumn = {
            enabled = false,
        },
        words = {
            enabled = false,
        },
        styles = {
            notification = {
                wo = {
                    wrap = true,
                },
            },
        },
    }

    local utils = require "tt.utils"

    utils.map("n", { "<leader>lg", "<leader>lt" }, function()
        Snacks.lazygit()
    end, { desc = "Open Lazygit" })

    utils.map("n", { "<leader>nh", "<leader>nn" }, function()
        Snacks.notifier.show_history()
    end, { desc = "Show notification history" })

    utils.map("n", "<leader>nd", function()
        Snacks.notifier.hide()
    end, { desc = "Hide all notifications" })
end

return M
