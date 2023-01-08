local M = {}

function M.setup()
    local actions = require "diffview.actions"

    require("diffview").setup {
        diff_binaries = false, -- Show diffs for binaries
        enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
        git_cmd = { "git" }, -- The git executable followed by default args.
        use_icons = true, -- Requires nvim-web-devicons
        watch_index = true, -- Update views and index buffers when the git index changes.
        icons = { -- Only applies when use_icons is true.
            folder_closed = "",
            folder_open = "",
        },
        signs = {
            fold_closed = "",
            fold_open = "",
            done = "✓",
        },
        view = {
            -- Configure the layout and behavior of different types of views.
            -- Available layouts:
            --   |'diff1_plain'
            --   |'diff2_horizontal'
            --   |'diff2_vertical'
            --   |'diff3_horizontal'
            --   |'diff3_vertical'
            --   |'diff3_mixed'
            --   |'diff4_mixed'
            -- For more info, see ':h diffview-config-view.x.layout'.
            default = {
                -- Config for changed files, and staged files in diff views.
                layout = "diff2_horizontal",
            },
            merge_tool = {
                -- Config for conflicted files in diff views during a merge or rebase.
                layout = "diff3_horizontal",
                disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
            },
            file_history = {
                -- Config for changed files in file history views.
                layout = "diff2_horizontal",
            },
        },
        file_panel = {
            listing_style = "tree", -- One of 'list' or 'tree'
            tree_options = { -- Only applies when listing_style is 'tree'
                flatten_dirs = true, -- Flatten dirs that only contain one single dir
                folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'
            },
            win_config = { -- See ':h diffview-config-win_config'
                position = "left",
                width = 35,
                win_opts = {},
            },
        },
        file_history_panel = {
            git = {
                log_options = { -- See ':h diffview-config-log_options'
                    single_file = {
                        diff_merges = "combined",
                    },
                    multi_file = {
                        diff_merges = "first-parent",
                    },
                },
                win_config = { -- See ':h diffview-config-win_config'
                    position = "bottom",
                    height = 16,
                    win_opts = {},
                },
            },
        },
        commit_log_panel = {
            win_config = { -- See ':h diffview-config-win_config'
                win_opts = {},
            },
        },
        default_args = { -- Default args prepended to the arg-list for the listed commands
            DiffviewOpen = {},
            DiffviewFileHistory = { "%" },
        },
        hooks = {}, -- See ':h diffview-config-hooks'
        keymaps = {
            disable_defaults = false, -- Disable the default keymaps
            view = {
                -- The `view` bindings are active in the diff buffers, only when the current tabpage is a Diffview
                ["<Tab>"] = actions.select_next_entry, -- Open the diff for the next file
                ["<S-Tab>"] = actions.select_prev_entry, -- Open the diff for the previous file
                ["gf"] = actions.goto_file, -- Open the file in a new split in the previous tabpage
                ["<C-w><C-x>"] = actions.goto_file_split, -- Open the file in a new split
                ["<C-w><C-t>"] = actions.goto_file_tab,
                ["<leader>e"] = actions.focus_files, -- Bring focus to the files panel
                ["<leader>b"] = actions.toggle_files, -- Toggle the files panel
                ["q"] = "<Cmd>DiffviewClose<CR>",
            },
            file_panel = {
                ["j"] = actions.next_entry, -- Bring the cursor to the next file entry
                ["<Down>"] = actions.next_entry,
                ["k"] = actions.prev_entry, -- Bring the cursor to the previous file entry
                ["<Up>"] = actions.prev_entry,
                ["<CR>"] = actions.select_entry, -- Open the diff for the selected entry
                ["o"] = actions.select_entry,
                ["<2-LeftMouse>"] = actions.select_entry,
                ["-"] = actions.toggle_stage_entry, -- Stage / unstage the selected entry
                ["S"] = actions.stage_all, -- Stage all entries
                ["U"] = actions.unstage_all, -- Unstage all entries
                ["X"] = actions.restore_entry, -- Restore entry to the state on the left side
                ["R"] = actions.refresh_files, -- Update stats and entries in the file list
                ["L"] = actions.open_commit_log, -- Open the commit log panel
                ["<C-b>"] = actions.scroll_view(-0.25), -- Scroll the view up
                ["<C-f>"] = actions.scroll_view(0.25), -- Scroll the view down
                ["<Tab>"] = actions.select_next_entry,
                ["<S-Tab>"] = actions.select_prev_entry,
                ["gf"] = actions.goto_file,
                ["<C-w><C-x>"] = actions.goto_file_split,
                ["<C-w><C-t>"] = actions.goto_file_tab,
                ["i"] = actions.listing_style, -- Toggle between 'list' and 'tree' views
                ["f"] = actions.toggle_flatten_dirs, -- Flatten empty subdirectories in tree listing style
                ["<leader>e"] = actions.focus_files,
                ["<leader>b"] = actions.toggle_files,
                ["q"] = "<Cmd>DiffviewClose<CR>",
            },
            file_history_panel = {
                ["g!"] = actions.options, -- Open the option panel
                ["<C-A-d>"] = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
                ["y"] = actions.copy_hash, -- Copy the commit hash of the entry under the cursor
                ["L"] = actions.open_commit_log,
                ["zR"] = actions.open_all_folds,
                ["zM"] = actions.close_all_folds,
                ["j"] = actions.next_entry,
                ["<Down>"] = actions.next_entry,
                ["k"] = actions.prev_entry,
                ["<Up>"] = actions.prev_entry,
                ["<CR>"] = actions.select_entry,
                ["o"] = actions.select_entry,
                ["<2-LeftMouse>"] = actions.select_entry,
                ["<C-b>"] = actions.scroll_view(-0.25),
                ["<C-f>"] = actions.scroll_view(0.25),
                ["<Tab>"] = actions.select_next_entry,
                ["<S-Tab>"] = actions.select_prev_entry,
                ["gf"] = actions.goto_file,
                ["<C-w><C-x>"] = actions.goto_file_split,
                ["<C-w><C-t>"] = actions.goto_file_tab,
                ["<leader>e"] = actions.focus_files,
                ["<leader>b"] = actions.toggle_files,
                ["q"] = "<Cmd>DiffviewClose<CR>",
            },
            option_panel = {
                ["<tab>"] = actions.select_entry,
                ["q"] = actions.close,
            },
        },
    }
end

return M
