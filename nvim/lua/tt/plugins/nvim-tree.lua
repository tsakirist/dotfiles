local M = {}

function M.setup()
    vim.g.nvim_tree_quit_on_open = 1 -- Closes the tree when you open a file
    vim.g.nvim_tree_indent_markers = 1 -- This option shows indent markers when folders are open
    vim.g.nvim_tree_git_hl = 1 -- Will enable file highlight for git attributes (can be used without the icons)
    vim.g.nvim_tree_highlight_opened_files = 1 -- Will enable folder and file icon highlight for opened files/directories
    vim.g.nvim_tree_root_folder_modifier = ":~" -- Default. See :help filename-modifiers for more options
    vim.g.nvim_tree_add_trailing = 1 -- Append a trailing slash to folder names
    vim.g.nvim_tree_group_empty = 1 -- Compact folders that only contain a single folder into one node
    vim.g.nvim_tree_disable_window_picker = 0 -- Will disable the window picker
    vim.g.nvim_tree_icon_padding = " " -- Used for rendering the space between the icon and the filename.
    vim.g.nvim_tree_respect_buf_cwd = 1 -- Will change cwd of nvim-tree to that of new buffer's when opening nvim-tree
    vim.g.nvim_tree_git_hl = 0 -- Disable this for better perfomance
    vim.g.nvim_tree_show_icons = { -- Disable/enable icons per type, disable git for better perfomance
        git = 0,
        folders = 1,
        files = 1,
        folder_arrows = 1,
    }
    vim.g.nvim_tree_icons = { -- Set the desired icons to display
        default = "",
        symlink = "",
        git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "★",
            deleted = "",
            ignored = "◌",
        },
        folder = {
            arrow_open = "",
            arrow_closed = "",
            open = "",
            default = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
        },
    }

    -- Custom mappings
    local tree_cb = require("nvim-tree.config").nvim_tree_callback
    local nvim_tree_mappings = {
        { key = { "<CR>", "o", "<2-LeftMouse>" }, cb = tree_cb "edit" },
        { key = { "<C-]>", "+" }, cb = tree_cb "cd" },
        { key = "<C-v>", cb = tree_cb "vsplit" },
        { key = "<C-x>", cb = tree_cb "split" },
        { key = "<C-t>", cb = tree_cb "tabnew" },
        { key = "<", cb = tree_cb "prev_sibling" },
        { key = ">", cb = tree_cb "next_sibling" },
        { key = "P", cb = tree_cb "parent_node" },
        { key = "<BS>", cb = tree_cb "close_node" },
        { key = "<S-CR>", cb = tree_cb "close_node" },
        { key = "<Tab>", cb = tree_cb "preview" },
        { key = "K", cb = tree_cb "first_sibling" },
        { key = "J", cb = tree_cb "last_sibling" },
        { key = "I", cb = tree_cb "toggle_ignored" },
        { key = "H", cb = tree_cb "toggle_dotfiles" },
        { key = "R", cb = tree_cb "refresh" },
        { key = "a", cb = tree_cb "create" },
        { key = "d", cb = tree_cb "remove" },
        { key = "r", cb = tree_cb "rename" },
        { key = "<C-r>", cb = tree_cb "full_rename" },
        { key = "x", cb = tree_cb "cut" },
        { key = "c", cb = tree_cb "copy" },
        { key = "p", cb = tree_cb "paste" },
        { key = "y", cb = tree_cb "copy_name" },
        { key = "Y", cb = tree_cb "copy_path" },
        { key = "gy", cb = tree_cb "copy_absolute_path" },
        { key = "[c", cb = tree_cb "prev_git_item" },
        { key = "]c", cb = tree_cb "next_git_item" },
        { key = "-", cb = tree_cb "dir_up" },
        { key = "s", cb = tree_cb "system_open" },
        { key = "q", cb = tree_cb "close" },
        { key = "g?", cb = tree_cb "toggle_help" },
    }

    require("nvim-tree").setup {
        disable_netrw = false, -- Disables netrw
        hijack_netrw = true, -- Prevents netrw from automatically opening when opening directories
        open_on_setup = false, -- Don't open when running setup
        ignore_ft_on_setup = { -- Ignore filetypes when running setup
            "startify",
            "vista_kind",
        },
        auto_close = false, -- Do not close neovim when nvim-tree is the last window
        open_on_tab = true, -- Open tree automatically when switching tab or opening new one
        update_to_buf_dir = { -- Hijacks new directory buffers when they are opened, opens the tree when typing `vim $DIR` or `vim`
            enable = true,
            auto_open = true, -- Open the tree if it was previsouly closed
        },
        hijack_cursor = false, -- When moving cursor in the tree, will position the cursor at the start of the file on the current line
        update_cwd = true, -- Update the tree cwd when changing nvim's directory (DirChanged event)
        update_focused_file = { -- Update tree to follow the focused file
            enable = false,
            update_cwd = false, -- Update the root directory of the tree to the one of the folder containing the file
            ignore_list = {},
        },
        system_open = { -- Configuration options for the system command, 's' in the tree by default
            cmd = nil, -- The command to run, nil should work on most cases
            args = {}, -- The command arguments as a list
        },
        diagnostics = { -- Lsp diagnostics in the signcolumn
            enable = false,
            icons = {
                hint = "",
                info = "",
                warning = "",
                error = "",
            },
        },
        git = { -- Git integration with icons and colors
            enable = true, -- Enable the feature
            ignore = true, -- Ignore files base on .gitignore
            timeout = 500, -- Kill the git process after some time if takes too long
        },
        view = { -- Configuration options for the view
            width = 45, -- Width of the window, can be either columns or string in '%'
            height = 30, -- Height of the window, can be either columns or string in '%'
            side = "left", -- The side where the tree should open
            hide_root_folder = false, -- Hide the root folder
            auto_resize = true, -- Resize the tree when opening a file
            number = false, -- Print line number in front of each line
            relativenumber = false, -- Show line number relative to the line with the cursor
            signcolumn = "yes", -- Show diagnostic sign column
            mappings = {
                custom_only = true, -- Disable default keybindings
                list = nvim_tree_mappings, -- List with the custom keybindings
            },
        },
        filters = {
            dotfiles = false, -- Hide files and folders starting with a dot '.'
            custom = { -- Do not load and display on these folders
                ".git",
                "node_modules",
                ".cache",
            },
        },
    }

    local utils = require "tt.utils"
    utils.map("n", "<leader>nt", "<Cmd>NvimTreeToggle<CR>")
    utils.map("n", "<leader>nf", "<Cmd>NvimTreeFindFile<CR>")
end

return M
