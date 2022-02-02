local M = {}

local actions = require "telescope.actions"
local actions_state = require "telescope.actions.state"
local actions_layout = require "telescope.actions.layout"
local trouble = require "trouble.providers.telescope"

function M.setup()
    require("telescope").setup {
        defaults = {
            dynamic_preview_title = true, -- Change the preview title dynamically to the filename
            prompt_prefix = "  ",
            selection_caret = "❯ ",
            winblend = 0,
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
            file_ignore_patterns = { "node_modules", "%.git" },
            mappings = {
                i = {
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
        pickers = {
            find_files = {
                follow = true, -- Follow synbolic links
                hidden = true, -- Show hidden files
                no_ignore = true, -- Show files that are ignored by git
            },
        },
        extensions = {
            fzf = {
                fuzzy = true, -- False will only do exact matching
                override_generic_sorter = true, -- Override the generic sorter
                override_file_sorter = true, -- Override the file sorter
                case_mode = "smart_case", -- "ignore_case" or "respect_case" or "smart_case"
            },
            packer = {
                theme = "ivy",
                layout_config = {
                    height = 0.5,
                },
            },
        },
    }

    -- Load extensions
    require("telescope").load_extension "fzf"
    require("telescope").load_extension "packer"

    -- Set keybindings
    local utils = require "tt.utils"
    utils.map("n", "<leader>T", "<Cmd>Telescope<CR>")
    utils.map("n", "<leader>fb", "<Cmd>Telescope buffers<CR>")
    utils.map("n", "<leader>fc", "<Cmd>Telescope commands<CR>")
    utils.map("n", "<leader>ff", "<Cmd>Telescope find_files<CR>")
    utils.map("n", "<leader>fF", "<Cmd>Telescope git_files<CR>")
    utils.map("n", "<leader>fH", "<Cmd>Telescope highlights<CR>")
    utils.map("n", "<leader>fM", "<Cmd>Telescope man_pages<CR>")
    utils.map("n", "<leader>fo", "<Cmd>Telescope oldfiles<CR>")
    utils.map("n", "<leader>fO", "<Cmd>Telescope vim_options<CR>")
    utils.map("n", "<leader>fw", "<Cmd>Telescope grep_string<CR>")
    utils.map("n", "<leader>fp", "<Cmd>Telescope packer<CR>")
    utils.map("n", "<leader>fs", "<Cmd>Telescope lsp_document_symbols<CR>")
    utils.map("n", "<leader>fT", "<Cmd>Telescope tags<CR>")
    utils.map("n", "<leader>f:", "<Cmd>Telescope command_history<CR>")
    utils.map("n", "<leader>f/", "<Cmd>Telescope search_history<CR>")
    utils.map("n", "<leader>fh", "<Cmd>lua require'telescope.builtin'.help_tags({layout_strategy = 'vertical'})<CR>")
    utils.map("n", "<leader>fg", "<Cmd>lua require'telescope.builtin'.live_grep({layout_strategy = 'vertical'})<CR>")
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
    utils.map("n", "<leader>fv", "<Cmd>lua require'tt.plugins.telescope'.find_in_nvim_config()<CR>")
    utils.map("n", "<leader>mr", "<Cmd>lua require'tt.plugins.telescope'.reload_modules()<CR>")
end

-- Define custom functions for telescope
function M.find_in_nvim_config()
    require("telescope.builtin").find_files {
        prompt_title = "Nvim Config",
        cwd = vim.fn.stdpath "config",
    }
end

-- Picker that allows to reload a Lua module
function M.reload_modules()
    -- Taken from https://ustrajunior.com/posts/reloading-neovim-config-with-telescope/

    -- Telescope will give us something like tt/module.lua,
    -- so this function converts the selected entry to
    -- the module name: tt.module
    local function get_module_name(module)
        local module_name

        module_name = module:gsub("%.lua", "")
        module_name = module_name:gsub("%/", ".")
        module_name = module_name:gsub("%.init", "")

        return module_name
    end

    local opts = {
        prompt_title = "Lua modules",
        cwd = vim.fn.stdpath "config" .. "/lua",
        attach_mappings = function(_, map)
            -- Mappings:
            --  1. <Enter>: Reloads the selected module
            --  2. <C-o>: Opens the lua module file
            map("i", "<Enter>", function(_)
                local entry = actions_state.get_selected_entry()
                local name = get_module_name(entry.value)
                _G.Reload(name)
                _G.Print(name .. " has been reloaded")
            end)
            map("i", "<C-o>", actions.select_default)
            return true
        end,
    }

    -- Call the builtin method to list files
    require("telescope.builtin").find_files(opts)
end

return M
