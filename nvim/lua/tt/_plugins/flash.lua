local M = {}

function M.setup()
    local flash = require "flash"

    flash.setup {
        modes = {
            search = {
                enabled = false,
            },
            char = {
                enabled = true,
                jump_labels = true,
                multi_line = false,
                highlight = {
                    backdrop = false,
                },
                jump = {
                    autojump = true,
                },
            },
        },
    }

    local utils = require "tt.utils"

    utils.map({ "n", "x", "o" }, "<M-s>", function()
        flash.jump()
    end, { desc = "Flash" })

    utils.map({ "n", "x", "o" }, "<M-S>", function()
        flash.treesitter()
    end, { desc = "Flash Treesitter" })

    utils.map("c", "<M-s>", function()
        flash.toggle()
    end, { desc = "Toggle Flash Search" })

    utils.map("o", "r", function()
        flash.remote()
    end, { desc = "Remote Flash" })

    utils.map({ "x", "o" }, "R", function()
        flash.treesitter_search()
    end, { desc = "Flash Treesitter Search" })
end

return M
