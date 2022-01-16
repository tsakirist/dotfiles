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

        callbacks = {
            ["github.com"] = require("gitlinker.hosts").get_github_type_url,
            ["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
            ["try.gitea.io"] = require("gitlinker.hosts").get_gitea_type_url,
            ["codeberg.org"] = require("gitlinker.hosts").get_gitea_type_url,
            ["bitbucket.org"] = require("gitlinker.hosts").get_bitbucket_type_url,
            ["try.gogs.io"] = require("gitlinker.hosts").get_gogs_type_url,
            ["git.sr.ht"] = require("gitlinker.hosts").get_srht_type_url,
            ["git.launchpad.net"] = require("gitlinker.hosts").get_launchpad_type_url,
            ["repo.or.cz"] = require("gitlinker.hosts").get_repoorcz_type_url,
            ["git.kernel.org"] = require("gitlinker.hosts").get_cgit_type_url,
            ["git.savannah.gnu.org"] = require("gitlinker.hosts").get_cgit_type_url,
        },

        -- Default mapping to call url generation with action_callback
        mappings = "<leader>gy",
    }

    local utils = require "tt.utils"
    utils.map(
        "n",
        "<leader>go",
        "<Cmd>lua require'gitlinker'.get_buf_range_url('n', { action_callback = require'gitlinker.actions'.open_in_browser})<CR>"
    )
    utils.map(
        "v",
        "<leader>go",
        "<Cmd>lua require'gitlinker'.get_buf_range_url('v', { action_callback = require'gitlinker.actions'.open_in_browser})<CR>"
    )
    utils.map(
        "n",
        "<leader>gO",
        "<Cmd>lua require'gitlinker'.get_repo_url({ action_callback = require'gitlinker.actions'.open_in_browser})<CR>"
    )
    utils.map("n", "<leader>gY", "<Cmd>lua require'gitlinker'.get_repo_url()<CR>")
end

return M
