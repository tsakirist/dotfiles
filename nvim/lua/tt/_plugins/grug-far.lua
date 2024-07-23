local M = {}

function M.setup()
    local grug_far = require "grug-far"
    grug_far.setup {
        transient = true,
        keymaps = {
            qflist = { n = "" },
            historyOpen = { n = "<localleader>h" },
        },
    }

    local utils = require "tt.utils"

    utils.map("n", "<leader>sr", grug_far.grug_far, {
        desc = "Search and replace files",
    })

    utils.map("n", "<leader>sf", function()
        grug_far.grug_far { prefills = { flags = vim.fn.expand "%" } }
    end, { desc = "Search and replace in current file" })

    utils.map("n", "<leader>sw", function()
        grug_far.grug_far { prefills = { flags = vim.fn.expand "<cword" } }
    end, { desc = "Search and replace for current word" })
end

return M
