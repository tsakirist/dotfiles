local M = {}

function M.setup()
    -- Do not allow plugin defined mappings
    vim.g.git_messenger_no_default_mappings = true

    -- Insert cusor inside pop-up window
    vim.g.git_messenger_always_into_popupa = true

    -- Configure the pop-up window
    vim.g.git_messenger_floating_win_opts = {
        border = "shadow",
    }

    local utils = require "tt.utils"
    utils.map("n", "<leader>gm", "<Cmd>GitMessenger<CR>")
end

return M
