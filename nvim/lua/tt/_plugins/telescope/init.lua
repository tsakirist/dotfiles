local M = {}

local actions = require "telescope.actions"
local actions_layout = require "telescope.actions.layout"
local telescope_config = require "telescope.config"
local trouble = require "trouble.providers.telescope"

--- Extend default telescope vimgrep_arguments
local function extended_vimgrep_arguments()
    local vimgrep_arguments = telescope_config.values.vimgrep_arguments
    table.insert(vimgrep_arguments, "--follow")
    return vimgrep_arguments
end

function M.setup()
    require("telescope").setup {
        defaults = {
            dynamic_preview_title = true,
            selection_caret = "❯ ",
            prompt_prefix = "  ",
            winblend = 0,
            wrap_results = false,
            initial_mode = "insert",
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
            file_ignore_patterns = { "node_modules", "%.git", "%.cache" },
            vimgrep_arguments = extended_vimgrep_arguments(),
            mappings = {
                i = {
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<CR>"] = actions.select_default + actions.center,
                    ["<C-c>"] = actions.smart_send_to_qflist + actions.open_qflist,
                    ["<C-l>"] = actions.smart_send_to_loclist + actions.open_loclist,
                    ["<C-r>"] = trouble.open_with_trouble,
                    ["<C-t>"] = actions.select_tab,
                    ["<C-q>"] = actions.close,
                    ["<C-Down>"] = actions.cycle_history_next,
                    ["<C-Up>"] = actions.cycle_history_prev,
                    ["<M-m>"] = actions_layout.toggle_mirror,
                    ["<M-p>"] = actions_layout.toggle_prompt_position,
                    ["?"] = actions_layout.toggle_preview,
                },
                n = {
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-r>"] = trouble.open_with_trouble,
                    ["<C-t>"] = actions.select_tab,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<M-m>"] = actions_layout.toggle_mirror,
                    ["<M-p>"] = actions_layout.toggle_prompt_position,
                    ["?"] = actions_layout.toggle_preview,
                },
            },
        },
        pickers = {
            find_files = {
                follow = true, -- Follow synbolic links
                hidden = true, -- Show hidden files
                no_ignore = true, -- Show files that are ignored by git
            },
            colorscheme = {
                enable_preview = true,
            },
        },
        extensions = require("tt._plugins.telescope.extensions").extensions,
    }

    require("tt._plugins.telescope.extensions").setup()
    require("tt._plugins.telescope.keymaps").setup()
    require("tt._plugins.telescope.commands").setup()
end

return M
