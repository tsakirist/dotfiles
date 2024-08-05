local M = {}

local function set_no_wrap()
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("tt.GrugFar", { clear = true }),
        pattern = "grug-far-help",
        callback = function()
            vim.wo.wrap = false
        end,
        desc = "Disable wrap for grug-far-help",
    })
end

function M.setup()
    local grug_far = require "grug-far"
    grug_far.setup {
        transient = true,
        keymaps = {
            qflist = { n = "" },
            historyOpen = { n = "<localleader>h" },
        },
    }

    set_no_wrap()

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
