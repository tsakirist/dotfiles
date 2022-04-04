local M = {}

function M.setup()
    -- Remove deprecated commands
    vim.g.neo_tree_remove_legacy_commands = 1

    require("neo-tree").setup {
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = false,
        enable_diagnostics = true,
        default_component_configs = {
            indent = {
                indent_size = 2,
                padding = 1,
                with_markers = true,
                indent_marker = "│",
                last_indent_marker = "└",
                highlight = "NeoTreeIndentMarker",
                with_expanders = nil, -- if true and file nesting is enabled, will enable expanders
                expander_collapsed = "",
                expander_highlight = "NeoTreeExpander",
                expander_expanded = "",
            },
            icon = {
                folder_closed = "",
                folder_open = "",
                folder_empty = "ﰊ",
                default = "*",
            },
            modified = {
                symbol = "[+]",
                highlight = "NeoTreeModified",
            },
            name = {
                trailing_slash = false,
                use_git_status_colors = true,
            },
            git_status = {
                symbols = {
                    added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
                    modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
                    deleted = "✖", -- this can only be used in the git_status source
                    renamed = "", -- this can only be used in the git_status source
                    untracked = "",
                    ignored = "",
                    unstaged = "",
                    staged = "",
                    conflict = "",
                },
            },
        },
        window = {
            position = "left",
            width = 40,
            mappings = {
                ["<2-LeftMouse>"] = "open",
                ["<cr>"] = "open",
                ["o"] = "open",
                ["<C-x>"] = "open_split",
                ["<C-v>"] = "open_vsplit",
                ["t"] = "open_tabnew",
                ["a"] = "add",
                ["d"] = "delete",
                ["r"] = "rename",
                ["y"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
                ["c"] = "copy",
                ["m"] = "move",
                ["q"] = "close_window",
                ["A"] = "add_directory",
                ["C"] = "close_node",
                ["R"] = "refresh",
            },
        },
        nesting_rules = {},
        filesystem = {
            filtered_items = {
                visible = false, -- when true, they will just be displayed differently than normal items
                hide_dotfiles = true,
                hide_gitignored = true,
                hide_by_name = {
                    ".DS_Store",
                    "thumbs.db",
                    "node_modules",
                },
                never_show = { -- remains hidden even if visible is toggled to true
                    --".DS_Store",
                    --"thumbs.db"
                },
            },
            follow_current_file = false, -- This will find and focus the file in the active buffer every time
            use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
            hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
            window = {
                mappings = {
                    ["<bs>"] = "navigate_up",
                    ["."] = "set_root",
                    ["H"] = "toggle_hidden",
                    ["/"] = "fuzzy_finder",
                    ["f"] = "filter_on_submit",
                    ["<M-w>"] = "clear_filter",
                },
            },
        },
        buffers = {
            show_unloaded = true,
            window = {
                mappings = {
                    ["<bs>"] = "navigate_up",
                    ["."] = "set_root",
                    ["bd"] = "buffer_delete",
                },
            },
        },
        git_status = {
            window = {
                position = "float",
                mappings = {
                    ["A"] = "git_add_all",
                    ["gu"] = "git_unstage_file",
                    ["ga"] = "git_add_file",
                    ["gr"] = "git_revert_file",
                    ["gc"] = "git_commit",
                    ["gp"] = "git_push",
                    ["gg"] = "git_commit_and_push",
                },
            },
        },
    }

    local utils = require "tt.utils"
    utils.map("n", "<leader>nt", "<Cmd>Neotree toggle<CR>")
    utils.map("n", "<leader>nf", "<Cmd>Neotree toggle reveal<CR>")
end

return M
