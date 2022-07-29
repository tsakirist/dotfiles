local M = {}

function M.setup()
    local utils = require "tt.utils"

    -- Hold the instance of the last notification for replacement
    local venn_notification = nil

    local function venn_toggle()
        local title = "Venn"
        if vim.b.venn_enabled == nil then
            vim.b.venn_enabled = true
            vim.cmd.setlocal "virtualedit=all"

            utils.map("n", "J", "<C-v>j:VBox<CR>", { buffer = true })
            utils.map("n", "K", "<C-v>k:VBox<CR>", { buffer = true })
            utils.map("n", "L", "<C-v>l:VBox<CR>", { buffer = true })
            utils.map("n", "H", "<C-v>h:VBox<CR>", { buffer = true })
            utils.map("v", "B", ":VBox<CR>", { buffer = true })
        else
            vim.b.venn_enabled = nil
            vim.cmd.setlocal "virtualedit="
            vim.cmd.mapclear "<buffer>"
        end

        venn_notification = vim.notify(
            ("Venn has been %s!"):format(vim.b.venn_enabled and "enabled" or "disabled"),
            vim.log.levels.INFO,
            {
                title = title,
                replace = venn_notification,
            }
        )
    end

    utils.map("n", "<leader>vt", venn_toggle)
end

return M
