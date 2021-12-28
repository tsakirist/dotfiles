-- Nvim-tree configurations

vim.g.nvim_tree_quit_on_open = 1 -- closes the tree when you open a file
vim.g.nvim_tree_indent_markers = 1 -- this option shows indent markers when folders are open
vim.g.nvim_tree_git_hl = 1 -- will enable file highlight for git attributes (can be used without the icons)
vim.g.nvim_tree_highlight_opened_files = 1 -- will enable folder and file icon highlight for opened files/directories
vim.g.nvim_tree_root_folder_modifier = ":~" -- default. See :help filename-modifiers for more options
vim.g.nvim_tree_add_trailing = 1 -- append a trailing slash to folder names
vim.g.nvim_tree_group_empty = 1 -- compact folders that only contain a single folder into one node
vim.g.nvim_tree_disable_window_picker = 0 -- will disable the window picker
vim.g.nvim_tree_icon_padding = " " -- used for rendering the space between the icon and the filename.
vim.g.nvim_tree_respect_buf_cwd = 1 -- will change cwd of nvim-tree to that of new buffer's when opening nvim-tree
vim.g.nvim_tree_git_hl = 0 -- disable this for better perfomance
vim.g.nvim_tree_auto_ignore_ft = { -- do not load nvim-tree for these filetypes
    "startify",
}
vim.g.nvim_tree_show_icons = { -- disable/enable icons per type, disable git for better perfomance
    git = 0,
    folders = 1,
    files = 1,
    folder_arrows = 1,
}
vim.g.nvim_tree_icons = { -- set the desired icons to display
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
    disable_netrw = false, -- disables netrw
    hijack_netrw = true, -- prevents netrw from automatically opening when opening directories
    open_on_setup = false, -- don't open when running setup
    ignore_ft_on_setup = {}, -- ignore filetypes when running setup
    update_to_buf_dir = { -- hijacks new directory buffers when they are opened, opens the tree when typing `vim $DIR` or `vim`
        enable = true,
        auto_open = true, -- open the tree if it was previsouly closed
    },
    git = {
        enable = true, -- Enable git integration
        ignore = true, -- Ignore files base on .gitignore
        timeout = 500, -- Kill the git process after some time if takes too long
    },
    auto_close = false, -- do not close neovim when nvim-tree is the last window
    open_on_tab = true, -- open tree automatically when switching tab or opening new one
    hijack_cursor = false, -- when moving cursor in the tree, will position the cursor at the start of the file on the current line
    update_cwd = true, -- update the tree cwd when changing nvim's directory (DirChanged event)
    diagnostics = { -- lsp diagnostics in the signcolumn
        enable = false,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    update_focused_file = { -- do not update tree to follow the focused file
        enable = false,
        update_cwd = false, -- update the root directory of the tree to the one of the folder containing the file
        ignore_list = {},
    },
    system_open = { -- configuration options for the system command, 's' in the tree by default
        cmd = nil, -- the command to run, nil should work on most cases
        args = {}, -- the command arguments as a list
    },
    view = { -- configuration options for the view
        width = 45, -- width of the window, can be either columns or string in '%'
        height = 30, -- height of the window, can be either columns or string in '%'
        side = "left", -- the side where the tree should open
        auto_resize = true, -- resize the tree when opening a file
        mappings = {
            custom_only = true, -- disable default keybindings
            list = nvim_tree_mappings,
        },
    },
    filters = {
        dotfiles = false, -- hide files and folders starting with a dot '.'
        custom = { -- do not load and display on these folders
            ".git",
            "node_modules",
            ".cache",
        },
    },
}

-- Nvim-tree mappings
local utils = require "utils"

utils.map("n", "<leader>nt", "<Cmd>NvimTreeToggle<CR>")
utils.map("n", "<leader>nf", "<Cmd>NvimTreeFindFile<CR>")
