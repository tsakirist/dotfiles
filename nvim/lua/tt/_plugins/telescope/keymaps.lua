local custom_pickers = require "tt._plugins.telescope.pickers"

local M = {}

function M.setup()
    -- Set custom keybindings
    local utils = require "tt.utils"
    utils.map("n", "<leader>T", "<Cmd>Telescope<CR>")
    utils.map("n", "<leader>fa", "<Cmd>Telescope autocommands<CR>")
    utils.map("n", "<leader>fb", "<Cmd>Telescope buffers<CR>")
    utils.map("n", "<leader>fc", "<Cmd>Telescope commands<CR>")
    utils.map("n", "<leader>fC", "<Cmd>Telescope colorscheme<CR>")
    utils.map("n", "<leader>ff", "<Cmd>Telescope find_files<CR>")
    utils.map("n", "<leader>fF", "<Cmd>Telescope git_files<CR>")
    utils.map("n", "<leader>fH", "<Cmd>Telescope highlights<CR>")
    utils.map("n", "<leader>fM", "<Cmd>Telescope man_pages<CR>")
    utils.map("n", "<leader>fn", "<Cmd>Telescope notify<CR>")
    utils.map("n", "<leader>fo", "<Cmd>Telescope oldfiles<CR>")
    utils.map("n", "<leader>fO", "<Cmd>Telescope vim_options<CR>")
    utils.map("n", "<leader>fw", "<Cmd>Telescope grep_string<CR>")
    utils.map("n", "<leader>fp", "<Cmd>Telescope lazy<CR>")
    utils.map("n", "<leader>fs", "<Cmd>Telescope lsp_document_symbols<CR>")
    utils.map("n", "<leader>fT", "<Cmd>Telescope tags<CR>")
    utils.map("n", "<leader>f:", "<Cmd>Telescope command_history<CR>")
    utils.map("n", "<leader>f/", "<Cmd>Telescope search_history<CR>")
    utils.map("n", "<leader>fg", "<Cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
    utils.map("n", "<leader>fh", "<Cmd>lua require'telescope.builtin'.help_tags({layout_strategy = 'vertical'})<CR>")
    utils.map(
        "n",
        "<leader>fl",
        "<Cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find({layout_strategy = 'vertical'})<CR>"
    )
    utils.map(
        "n",
        "<leader>fm",
        "<Cmd>lua require'telescope.builtin'.keymaps(require'telescope.themes'.get_ivy({}))<CR>"
    )

    utils.map("n", "<leader>fv", function()
        custom_pickers.action_in_nvim_config "find_files"
    end, { desc = "Find files in neovim config files" })

    utils.map("n", "<leader>gv", function()
        custom_pickers.action_in_nvim_config "live_grep"
    end, { desc = "Live grep in neovim config files" })

    utils.map("n", "<leader>fS", custom_pickers.find_sessions, { desc = "Search startify sessions" })
end

return M
