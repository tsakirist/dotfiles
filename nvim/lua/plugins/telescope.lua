local utils = require "utils"

local actions = require "telescope.actions"
local actions_layout = require "telescope.actions.layout"
local trouble = require "trouble.providers.telescope"

require("telescope").setup {
    defaults = {
        prompt_prefix = "❯ ",
        selection_caret = "❯ ",
        winblend = 15,
        layout_strategy = "horizontal",
        layout_config = {
            prompt_position = "bottom",
            horizontal = {
                width = { padding = 0.1 },
                height = { padding = 0.1 },
                preview_width = 0.5,
                mirror = false,
            },
            vertical = {
                width = { padding = 0.1 },
                height = { padding = 0.1 },
                preview_height = 0.65,
                mirror = false,
            },
        },
        path_display = { shorten = 5 },
        sorting_strategy = "descending",
        set_env = { ["COLORTERM"] = "truecolor" },
        mappings = {
            i = {
                ["<Esc>"] = actions.close,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<CR>"] = actions.select_default + actions.center,
                ["<C-c>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<C-l>"] = actions.smart_send_to_loclist + actions.open_loclist,
                ["<C-t>"] = trouble.open_with_trouble,
                ["<C-q>"] = actions.close,
                ["<M-m>"] = actions_layout.toggle_mirror,
                ["<M-p>"] = actions_layout.toggle_prompt_position,
                ["?"] = actions_layout.toggle_preview,
            },
            n = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-t>"] = trouble.open_with_trouble,
                ["<C-k>"] = actions.move_selection_previous,
                ["<M-m>"] = actions_layout.toggle_mirror,
                ["<M-p>"] = actions_layout.toggle_prompt_position,
                ["?"] = actions_layout.toggle_preview,
            },
        },
    },
}

local M = {}

-- Define custom functions for telescope
function M.find_in_installed_plugins()
    require("telescope.builtin").find_files {
        prompt_title = "Plugins",
        cwd = vim.fn.stdpath "data" .. "/site/pack/packer/start",
    }
end

-- Set up telescope mappings
utils.map("n", "<leader>fb", "<Cmd>Telescope buffers<CR>")
utils.map("n", "<leader>fc", "<Cmd>Telescope commands<CR>")
utils.map("n", "<leader>ff", "<Cmd>Telescope find_files<CR>")
utils.map("n", "<leader>fF", "<Cmd>Telescope git_files<CR>")
utils.map("n", "<leader>fH", "<Cmd>Telescope highlights<CR>")
utils.map("n", "<leader>fo", "<Cmd>Telescope oldfiles<CR>")
utils.map("n", "<leader>fO", "<Cmd>Telescope vim_options<CR>")
utils.map("n", "<leader>fw", "<Cmd>Telescope grep_string<CR>")
utils.map("n", "<leader>fT", "<Cmd>Telescope tags<CR>")
utils.map("n", "<leader>fs", "<Cmd>Telescope lsp_document_symbols<CR>")
utils.map("n", "<leader>f:", "<Cmd>Telescope command_history<CR>")
utils.map("n", "<leader>f/", "<Cmd>Telescope search_history<CR>")
utils.map("n", "<leader>fg", "<Cmd>lua require'telescope.builtin'.live_grep({layout_strategy = 'vertical'})<CR>")
utils.map("n", "<leader>fh", "<Cmd>lua require'telescope.builtin'.help_tags({layout_strategy = 'vertical'})<CR>")
utils.map(
    "n",
    "<leader>fl",
    "<Cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find({layout_strategy = 'vertical'})<CR>"
)
utils.map(
    "n",
    "<leader>fM",
    "<Cmd>lua require'telescope.builtin'.keymaps(require'telescope.themes'.get_dropdown({}))<CR>"
)
utils.map("n", "<leader>fv", "<Cmd>lua require'plugins.telescope'.find_in_installed_plugins()<CR>")

return M
