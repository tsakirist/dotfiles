local builtin = require "telescope.builtin"
local custom_pickers = require "tt._plugins.telescope.pickers"
local extensions = require("telescope").extensions
local themes = require "telescope.themes"
local utils = require "tt.utils"

local M = {}

function M.setup()
    -- stylua: ignore
    utils.map("n", "<leader>T", builtin.builtin, { desc = "Show telescope builtin" })
    utils.map("n", "<leader>fa", builtin.autocommands, { desc = "Search autocommands" })
    utils.map("n", "<leader>fb", builtin.buffers, { desc = "Search for open buffers " })
    utils.map("n", "<leader>fc", builtin.commands, { desc = "Search for commands" })
    utils.map("n", "<leader>ff", builtin.find_files, { desc = "Search for files" })
    utils.map("n", "<leader>fF", builtin.git_files, { desc = "Search for git files" })
    utils.map("n", "<leader>fH", builtin.highlights, { desc = "Search for highlights" })
    utils.map("n", "<leader>fM", builtin.man_pages, { desc = "Search for man pages" })
    utils.map("n", "<leader>fo", builtin.oldfiles, { desc = "Search for oldfiles" })
    utils.map("n", "<leader>fO", builtin.vim_options, { desc = "Search for vim options" })
    utils.map("n", "<leader>fw", builtin.grep_string, { desc = "Search for the string under cursor" })
    utils.map("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Search for LSP document symbols" })
    utils.map("n", "<leader>fT", builtin.tags, { desc = "Search for tags" })
    utils.map("n", "<leader>f;", builtin.resume, { desc = "Opens the previous telescope picker" })
    utils.map("n", "<leader>f:", builtin.command_history, { desc = "Search for command history" })
    utils.map("n", "<leader>f/", builtin.search_history, { desc = "Search history" })

    utils.map("n", "<leader>fh", function()
        builtin.help_tags { layout_strategy = "vertical" }
    end, { desc = "Search help tags" })

    utils.map("n", "<leader>fl", function()
        builtin.current_buffer_fuzzy_find { layout_strategy = "vertical", previewer = false }
    end, { desc = "Search current buffer" })

    utils.map("n", "<leader>fm", function()
        builtin.keymaps(themes.get_ivy())
    end, { desc = "List keymaps" })

    utils.map("n", "<leader>gb", function()
        extensions.egrepify.egrepify { prompt_title = "Live grep in open buffers", grep_open_files = true }
    end, { desc = "Live grep in open buffers" })

    utils.map("n", "<leader>fC", function()
        builtin.colorscheme(themes.get_ivy { layout_config = { height = 0.2 } })
    end, { desc = "List available colorschemes" })

    utils.map("n", "<leader>fv", function()
        custom_pickers.action_in_nvim_config "find_files"
    end, { desc = "Find files in neovim config files" })

    utils.map("n", "<leader>gv", function()
        custom_pickers.action_in_nvim_config "live_grep"
    end, { desc = "Live grep in neovim config files" })

    utils.map("n", "<leader>fS", custom_pickers.find_sessions, { desc = "Search startify sessions" })

    utils.map("n", "<leader>fp", extensions.lazy.lazy, { desc = "Search for installed plugins and perform actions" })
    utils.map("n", "<leader>fn", extensions.notify.notify, { desc = "Search for notifications" })
    utils.map("n", "<leader>fg", extensions.egrepify.egrepify, { desc = "Live grep" })
    utils.map("n", "<leader>fG", function()
        extensions.egrepify.egrepify { cwd = utils.get_git_root() }
    end, { desc = "Live grep from git root" })
end

return M
