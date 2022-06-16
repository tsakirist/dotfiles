local M = {}

function M.setup()
    local utils = require "tt.utils"

    local function venn_toggle()
        local title = "Venn"
        if vim.b.venn_enabled == nil then
            vim.b.venn_enabled = true
            vim.cmd [[setlocal virtualedit=all]]

            -- Draw a line on HJKL keystokes
            utils.map("n", "J", "<C-v>j:VBox<CR>", { buffer = true })
            utils.map("n", "K", "<C-v>k:VBox<CR>", { buffer = true })
            utils.map("n", "L", "<C-v>l:VBox<CR>", { buffer = true })
            utils.map("n", "H", "<C-v>h:VBox<CR>", { buffer = true })
            -- Draw a box by pressing "B" with visual selection
            utils.map("v", "B", ":VBox<CR>", { buffer = true })
        else
            vim.b.venn_enabled = nil
            vim.cmd [[setlocal virtualedit=]]
            vim.cmd [[mapclear <buffer>]]
        end

        vim.notify(("Venn has been %s!"):format(vim.b.venn_enabled and "enabled" or "disabled"), vim.log.levels.INFO, {
            title = title,
        })
    end

    utils.map("n", "<leader>vt", venn_toggle)
end

return M
