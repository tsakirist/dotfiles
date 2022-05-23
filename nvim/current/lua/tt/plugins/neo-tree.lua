local M = {}

function M.setup()
    -- Remove deprecated commands
    vim.g.neo_tree_remove_legacy_commands = 1

    require("neo-tree").setup {
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = false,
        enable_diagnostics = true,
        window = {
            position = "left",
            width = 40,
            mapping_options = {
                noremap = true,
                nowait = true,
            },
            mappings = {
                ["<2-leftmouse>"] = "open",
                ["<cr>"] = "open",
                ["o"] = "open",
                ["-"] = "navigate_up",
                ["<bs>"] = "none",
                ["<c-x>"] = "open_split",
                ["<c-v>"] = "open_vsplit",
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
                ["s"] = "none",
                ["w"] = "none",
                ["S"] = "none",
                ["A"] = "add_directory",
                ["C"] = "close_node",
                ["R"] = "refresh",
            },
        },
        default_component_configs = {
            container = {
                enable_character_fade = true,
            },
            indent = {
                indent_size = 2,
                padding = 1,
                with_markers = true,
                indent_marker = "│",
                last_indent_marker = "└",
                highlight = "NeoTreeIndentMarker",
                with_expanders = nil, -- If true and file nesting is enabled, will enable expanders
                expander_collapsed = "",
                expander_expanded = "",
                expander_highlight = "NeoTreeExpander",
            },
            icon = {
                folder_closed = "",
                folder_open = "",
                folder_empty = "ﰊ",
                default = "*",
                highlight = "NeoTreeFileIcon",
            },
            modified = {
                symbol = "[+]",
                highlight = "NeoTreeModified",
            },
            name = {
                trailing_slash = false,
                use_git_status_colors = true,
                highlight = "NeoTreeFileName",
            },
            git_status = {
                symbols = {
                    added = "",
                    modified = "",
                    deleted = "✖",
                    renamed = "",
                    untracked = "",
                    ignored = "",
                    unstaged = "",
                    staged = "",
                    conflict = "",
                },
            },
        },
        nesting_rules = {},
        filesystem = {
            filtered_items = {
                visible = false, -- When true, they will just be displayed differently than normal items
                hide_dotfiles = true,
                hide_gitignored = true,
                hide_hidden = true, -- only works on Windows for hidden files/directories
                hide_by_name = {
                    ".DS_Store",
                    "thumbs.db",
                    "node_modules",
                },
                hide_by_pattern = { -- Uses glob style patterns
                    --"*.meta"
                },
                never_show = { -- Remains hidden even if visible is toggled to true
                    --".DS_Store",
                    --"thumbs.db"
                },
            },
            follow_current_file = true, -- This will find and focus the file in the active buffer every time
            group_empty_dirs = false, -- When true, empty folders will be grouped together
            use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
            hijack_netrw_behavior = "open_default",
            window = {
                mappings = {
                    ["."] = "set_root",
                    ["H"] = "toggle_hidden",
                    ["/"] = "fuzzy_finder",
                    ["f"] = "filter_on_submit",
                    ["<M-l>"] = "clear_filter",
                },
            },
        },
        buffers = {
            show_unloaded = true,
            window = {
                mappings = {
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
