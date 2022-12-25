local M = {}

local actions = require "telescope.actions"
local actions_layout = require "telescope.actions.layout"
local actions_state = require "telescope.actions.state"
local config = require("telescope.config").values
local finders = require "telescope.finders"
local lga_actions = require "telescope-live-grep-args.actions"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local themes = require "telescope.themes"
local trouble = require "trouble.providers.telescope"

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
        extensions = {
            fzf = {
                fuzzy = true, -- False will only do exact matching
                override_generic_sorter = true, -- Override the generic sorter
                override_file_sorter = true, -- Override the file sorter
                case_mode = "smart_case", -- "ignore_case" or "respect_case" or "smart_case"
            },
            lazy = {
                theme = "ivy",
            },
            live_grep_args = {
                auto_quoting = true,
                mappings = {
                    i = {
                        -- This is required to overwirte the default mapping, which forces <C-k> keymapping
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-l>"] = lga_actions.quote_prompt(),
                        ["<C-l>g"] = lga_actions.quote_prompt { postfix = " --iglob " },
                        ["<C-l>t"] = lga_actions.quote_prompt { postfix = " -t" },
                    },
                },
            },
        },
    }

    -- Load extensions
    require("telescope").load_extension "fzf"
    require("telescope").load_extension "notify"
    require("telescope").load_extension "lazy"
    require("telescope").load_extension "live_grep_args"

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
    utils.map("n", "<leader>fh", "<Cmd>lua require'telescope.builtin'.help_tags({layout_strategy = 'vertical'})<CR>")
    utils.map("n", "<leader>fg", "<Cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
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
    utils.map("n", "<leader>fS", "<Cmd>lua require'tt.plugins.telescope'.find_sessions()<CR>")
end

--- Defines custom picker for searching in neovim config.
function M.find_in_nvim_config()
    require("telescope.builtin").find_files {
        prompt_title = "Nvim Config",
        cwd = vim.fn.stdpath "config",
    }
end

--- Defines a custom picker for selection sessions made with Startify session maanagement.
function M.find_sessions(opts)
    --- Gets the current session name from the picker, using regex.
    ---@return string filename
    local function get_session_name()
        local selection = actions_state.get_selected_entry().value
        local filename = selection:match "([^/]+)$"
        return filename
    end

    --- Calls `SLoad` on the selected session.
    ---@param prompt_bufnr number
    local function load_session(prompt_bufnr)
        local filename = get_session_name()
        actions.close(prompt_bufnr)
        vim.cmd.SLoad(filename)
    end

    --- Calls 'SDelete' on the selected session.
    local function delete_session()
        local filename = get_session_name()
        vim.cmd.SDelete { filename, bang = false }
    end

    --- Path where Startify stores saved sessions.
    local sessions_path = require("tt.plugins.startify").get_sessions_path()

    --- The find command to use for finding the sesions.
    local find_command = vim.tbl_flatten {
        "fd",
        ".",
        "--type",
        "f",
        sessions_path,
    }

    --- Optional options that can be passed to the picker and finder.
    opts = opts or {}

    --- The theme to use for the finder.
    opts = themes.get_dropdown()

    --- Use as the cwd the sessions_path directory, so that the maker can make
    --- use of it when populating the session entries.
    opts.cwd = sessions_path

    --- Use the appropriate entry_maker for the results.
    opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)

    --- Picker that will allow us to select a session to load or delete.
    pickers
        .new(opts, {
            prompt_title = "Session",
            results_title = sessions_path,
            finder = finders.new_oneshot_job(find_command, opts),
            sorter = config.file_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(load_session)
                local function inner_delete_session()
                    delete_session()
                    --- Refresh the UI after session deletion.
                    local current_picker = actions_state.get_current_picker(prompt_bufnr)
                    current_picker:refresh(finders.new_oneshot_job(find_command, opts))
                end
                map("n", "d", inner_delete_session)
                map("i", "<C-d>", inner_delete_session)
                return true
            end,
        })
        :find()
end

return M
