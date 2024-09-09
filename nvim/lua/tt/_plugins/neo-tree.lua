local M = {}

function M.setup()
    local icons = require "tt.icons"

    require("neo-tree").setup {
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = false,
        enable_diagnostics = true,
        sort_case_insensitive = false,
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
                ["<bs>"] = "none",
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
                ["z"] = "expand_all_nodes",
                ["s"] = "none",
                ["w"] = "none",
                ["S"] = "none",
                ["A"] = "add_directory",
                ["C"] = "close_node",
                ["R"] = "refresh",
                ["Z"] = "close_all_nodes",
                ["<C-d>"] = { "scroll_preview", config = { direction = -10 } },
                ["<C-u>"] = { "scroll_preview", config = { direction = 10 } },
                ["g?"] = "show_help",
                ["<"] = "prev_source",
                [">"] = "next_source",
                ["?"] = "none",
                ["oc"] = "none",
                ["od"] = "none",
                ["og"] = "none",
                ["om"] = "none",
                ["on"] = "none",
                ["os"] = "none",
                ["ot"] = "none",
            },
            fuzzy_finder_mappings = {
                ["<C-k>"] = "move_cursor_up",
                ["<C-j>"] = "move_cursor_down",
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
                with_expanders = nil,
                expander_collapsed = icons.misc.ArrowExpandedSmall,
                expander_expanded = icons.misc.ArrowExpandedSmall,
                expander_highlight = "NeoTreeExpander",
            },
            icon = {
                folder_closed = icons.document.FolderClosed,
                folder_open = icons.document.FolderOpen,
                folder_empty = icons.document.FolderEmpty,
                default = icons.misc.Star,
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
                symbols = {},
            },
            file_size = {
                enabled = false,
            },
            type = {
                enabled = false,
            },
            last_modified = {
                enabled = false,
            },
            created = {
                enabled = false,
            },
        },
        sources = {
            "filesystem",
        },
        filesystem = {
            filtered_items = {
                visible = false, -- When true, they will just be displayed differently than normal items
                hide_dotfiles = true,
                hide_gitignored = true,
                hide_hidden = true, -- only works on Windows for hidden files/directories
                hide_by_name = {
                    "node_modules",
                },
                hide_by_pattern = {}, -- Uses glob style patterns
                never_show = {}, -- Remains hidden even if visible is toggled to true
            },
            follow_current_file = {
                enabled = true, -- This will find and focus the file in the active buffer every time
            },
            group_empty_dirs = false, -- When true, empty folders will be grouped together
            use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes, instead of autocmds
            hijack_netrw_behavior = "disabled",
            window = {
                mappings = {
                    ["-"] = "navigate_up",
                    ["."] = "set_root",
                    ["f"] = "fuzzy_sorter",
                    ["F"] = "filter_on_submit",
                    ["<M-l>"] = "clear_filter",
                    ["H"] = "toggle_hidden",
                    ["/"] = "none",
                },
            },
        },
    }

    local utils = require "tt.utils"
    utils.map("n", "<leader>nt", function()
        vim.cmd.Neotree { "toggle" }
    end, { desc = "Toggle Neotree" })

    utils.map("n", "<leader>nf", function()
        vim.cmd.Neotree { "toggle", "reveal" }
    end, { desc = "Reveal current file in Neotree" })
end

return M
