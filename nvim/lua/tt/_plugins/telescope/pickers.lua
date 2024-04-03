local actions = require "telescope.actions"
local actions_state = require "telescope.actions.state"
local builtin = require "telescope.builtin"
local config = require("telescope.config").values
local extensions = require("telescope").extensions
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local previewers = require("tt._plugins.telescope.previewers").previewers
local themes = require "telescope.themes"

local M = {}

--- Custom pickers configuration.
M.pickers = {
    buffers = {
        mappings = {
            i = {
                ["<M-d>"] = actions.delete_buffer,
            },
        },
    },
    find_files = {
        follow = true, -- Follow synbolic links
        hidden = true, -- Show hidden files
        no_ignore = true, -- Show files that are ignored by git
    },
    colorscheme = {
        enable_preview = true,
    },
    git_commits = {
        previewer = previewers.delta,
    },
    git_bcommits = {
        previewer = previewers.delta,
    },
    git_status = {
        previewer = previewers.delta,
    },
    git_stash = {
        previewer = previewers.delta,
    },
    lsp_document_symbols = {
        symbol_width = 60,
    },
}

--- Custom pickers which operate in nvim config.
---@param action string: The action to perform ('find_files', 'live_grep').
function M.action_in_nvim_config(action)
    local path = vim.fn.stdpath "config"
    if action == "find_files" then
        builtin.find_files {
            prompt_title = string.format("Find files (%s)", path),
            cwd = path,
        }
    elseif action == "live_grep" then
        extensions.egrepify.egrepify {
            prompt_title = string.format("Grep files (%s)", path),
            cwd = path,
        }
    end
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
        vim.cmd.SDelete { filename, bang = true }
    end

    --- Path where Startify stores saved sessions.
    local sessions_path = require("tt._plugins.startify").sessions_path

    --- The find command to use for finding the sessions.
    local find_command = {
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
