local M = {}

function M.setup()
    require("grapple").setup {
        --- Hook to bind into the created window for the tags UI.
        ---@param window any: The window that displays the current tags.
        tag_hook = function(window)
            local TagActions = require "grapple.tag_actions"
            local App = require "grapple.app"
            local app = App.get()

            -- Open tag
            window:map("n", "o", function()
                local cursor = window:cursor()
                window:perform_close(TagActions.select, { index = cursor[1] })
            end, { desc = "Grapple open tag" })

            -- Open tag in horizontal split
            window:map("n", "<c-s>", function()
                local cursor = window:cursor()
                window:perform_close(TagActions.select, { index = cursor[1], command = vim.cmd.split })
            end, { desc = "Grapple open tag in split" })

            -- Open tag in vertical split
            window:map("n", "<c-v>", function()
                local cursor = window:cursor()
                window:perform_close(TagActions.select, { index = cursor[1], command = vim.cmd.vsplit })
            end, { desc = "Grapple open tag in vsplit" })

            -- Quick select tag
            for i, quick in ipairs(app.settings:quick_select()) do
                window:map("n", string.format("%s", quick), function()
                    window:perform_close(TagActions.select, { index = i })
                end, { desc = string.format("Grapple quick select %d", i) })
            end

            -- Send tags to quickfix list
            window:map("n", "<c-l>", function()
                window:perform_close(TagActions.quickfix)
            end, { desc = "Grapple send tags to quickfix" })

            -- Go "up" to scopes
            window:map("n", "-", function()
                window:perform_close(TagActions.open_scopes)
            end, { desc = "Grapple go to tags scopes" })

            -- Rename
            window:map("n", "r", function()
                local entry = window:current_entry()
                local path = entry.data.path
                window:perform_retain(TagActions.rename, { path = path })
            end, { desc = "Grapple rename tag" })
        end,
    }

    local utils = require "tt.utils"
    utils.map("n", "<leader>tt", "<Cmd>Grapple toggle<CR>", { desc = "Grapple toggle tag" })
    utils.map("n", "<leader>tn", "<Cmd>Grapple cycle forward<CR>", { desc = "Grapple go to next tag" })
    utils.map("n", "<leader>tp", "<Cmd>Grapple cycle backward<CR>", { desc = "Grapple go to previous tag" })
    utils.map("n", "<leader>tw", "<Cmd>Grapple toggle_tags<CR>", { desc = "Grapple toggle tags window" })

    for i = 1, 5 do
        utils.map("n", string.format("<leader>t%d", i), string.format("<Cmd>Grapple select index=%d<CR>", i), {
            desc = string.format("Grapple quick select tag=%d", i),
        })
    end
end

return M
