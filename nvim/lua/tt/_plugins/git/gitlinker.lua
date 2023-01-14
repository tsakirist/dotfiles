local M = {}

function M.setup()
    require("gitlinker").setup {
        opts = {
            -- Force the use of a specific remote
            remote = nil,

            -- Adds current line nr in the url for normal mode
            add_current_line_on_normal_mode = true,

            -- Callback for what to do with the url
            action_callback = require("gitlinker.actions").copy_to_clipboard,

            -- Print the url after performing the action
            print_url = false,
        },

        -- Default mapping to call url generation with action_callback
        mappings = "<leader>gy",
    }

    local utils = require "tt.utils"
    utils.map("n", "<leader>go", function()
        require("gitlinker").get_buf_range_url("n", { action_callback = utils.open_in_browser })
    end, { desc = "Open file in browser" })

    utils.map("v", "<leader>go", function()
        require("gitlinker").get_buf_range_url("v", { action_callback = utils.open_in_browser })
    end, { desc = "Open file in browser" })

    utils.map("n", "<leader>gO", function()
        require("gitlinker").get_repo_url { action_callback = utils.open_in_browser }
    end, { desc = "Open repository in browser" })

    utils.map("n", "<leader>gY", function()
        require("gitlinker").get_repo_url()
    end, { desc = "Copy repository URL to the clipboard" })
end

return M
