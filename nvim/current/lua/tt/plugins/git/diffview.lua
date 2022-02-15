local M = {}

function M.setup()
    local callback = require("diffview.config").diffview_callback

    require("diffview").setup {
        diff_binaries = false, -- Show diffs for binaries
        enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
        use_icons = true, -- Requires nvim-web-devicons
        icons = { -- Only applies when use_icons is true
            folder_closed = "",
            folder_open = "",
        },
        signs = {
            fold_closed = "",
            fold_open = "",
        },
        file_panel = {
            position = "left", -- One of 'left', 'right', 'top', 'bottom'
            width = 35, -- Only applies when position is 'left' or 'right'
            height = 10, -- Only applies when position is 'top' or 'bottom'
            listing_style = "tree", -- One of 'list' or 'tree'
            tree_options = { -- Only applies when listing_style is 'tree'
                flatten_dirs = true, -- Flatten dirs that only contain one single dir
                folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'
            },
        },
        file_history_panel = {
            position = "bottom",
            width = 35,
            height = 16,
            log_options = {
                max_count = 256, -- Limit the number of commits
                follow = false, -- Follow renames (only for single file)
                all = false, -- Include all refs under 'refs/' including HEAD
                merges = false, -- List only merge commits
                no_merges = false, -- List no merge commits
                reverse = false, -- List commits in reverse order
            },
        },
        default_args = { -- Default args prepended to the arg-list for the listed commands
            DiffviewOpen = {},
            DiffviewFileHistory = {},
        },
        hooks = {}, -- See ':h diffview-config-hooks'
        key_bindings = {
            disable_defaults = true, -- Disable the default key bindings
            view = { -- The `view` bindings are active in the diff buffers, only when the current tabpage is a Diffview
                ["<Tab>"] = callback "select_next_entry", -- Open the diff for the next file
                ["<S-tab>"] = callback "select_prev_entry", -- Open the diff for the previous file
                ["gf"] = callback "goto_file", -- Open the file in a new split in previous tabpage
                ["<C-w><C-f>"] = callback "goto_file_split", -- Open the file in a new split
                ["<C-w>gf"] = callback "goto_file_tab", -- Open the file in a new tabpage
                ["<leader>ff"] = callback "focus_files", -- Bring focus to the files panel
                ["<leader>tf"] = callback "toggle_files", -- Toggle the files panel
            },
            file_panel = {
                ["j"] = callback "next_entry", -- Bring the cursor to the next file entry
                ["k"] = callback "prev_entry", -- Bring the cursor to the previous file entry
                ["o"] = callback "select_entry", -- Open the diff for the selected entry
                ["<CR>"] = callback "select_entry", -- Open the diff for the selected entry
                ["s"] = callback "toggle_stage_entry", -- Stage / unstage the selected entry
                ["S"] = callback "stage_all", -- Stage all entries
                ["U"] = callback "unstage_all", -- Unstage all entries
                ["X"] = callback "restore_entry", -- Restore entry to the state on the left side
                ["R"] = callback "refresh_files", -- Update stats and entries in the file list
                ["<Tab>"] = callback "select_next_entry",
                ["<S-tab>"] = callback "select_prev_entry",
                ["gf"] = callback "goto_file",
                ["<C-w><C-f>"] = callback "goto_file_split",
                ["<C-w>gf"] = callback "goto_file_tab",
                ["l"] = callback "listing_style", -- Toggle between 'list' and 'tree' views
                ["f"] = callback "toggle_flatten_dirs", -- Flatten empty subdirectories in tree listing style
                ["<leader>ff"] = callback "focus_files", -- Bring focus to the files panel
                ["<leader>tf"] = callback "toggle_files", -- Toggle the files panel
            },
            file_history_panel = {
                ["g!"] = callback "options", -- Open the option panel
                ["<M-d>"] = callback "open_in_diffview", -- Open the entry under the cursor in a diffview
                ["y"] = callback "copy_hash", -- Copy the commit hash of the entry under the cursor
                ["zR"] = callback "open_all_folds",
                ["zM"] = callback "close_all_folds",
                ["j"] = callback "next_entry",
                ["k"] = callback "prev_entry",
                ["o"] = callback "select_entry",
                ["<CR>"] = callback "select_entry",
                ["<Tab>"] = callback "select_next_entry",
                ["<S-tab>"] = callback "select_prev_entry",
                ["gf"] = callback "goto_file",
                ["<C-w><C-f>"] = callback "goto_file_split",
                ["<C-w>gf"] = callback "goto_file_tab",
                ["<leader>ff"] = callback "focus_files", -- Bring focus to the files panel
                ["<leader>tf"] = callback "toggle_files", -- Toggle the files panel
            },
            option_panel = {
                ["<Tab>"] = callback "select",
                ["q"] = callback "close",
            },
        },
    }
end

vim.cmd [[
    cnoreabbrev dvo DiffviewOpen
    cnoreabbrev dvc DiffviewClose
    cnoreabbrev dvf DiffviewFileHistory
]]

return M
