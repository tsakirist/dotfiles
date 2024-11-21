local actions = require "telescope.actions"
local actions_state = require "telescope.actions.state"
local builtin = require "telescope.builtin"
local config = require("telescope.config").values
local extensions = require("telescope").extensions
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local entry_display = require "telescope.pickers.entry_display"
local pickers = require "telescope.pickers"
local previewers = require("tt._plugins.telescope.previewers").previewers
local themes = require "telescope.themes"
local icons = require "tt.icons"

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

---Pretty document symbols picker.
---@param opts? table Optional table with extra configuration options.
function M.document_symbols(opts)
    opts = opts or {}

    local original_entry_maker = make_entry.gen_from_lsp_symbols(opts)

    opts.entry_maker = function(line)
        local displayer = entry_display.create {
            separator = " ",
            items = {
                { width = 35 },
                { width = 3 },
                { remaining = true },
            },
        }

        local original_entry = original_entry_maker(line)
        original_entry.display = function(entry)
            return displayer {
                { entry.symbol_name },
                { icons.kind[entry.symbol_type], "TelescopeResultsField" },
                { entry.symbol_type:lower(), "TelescopeResultsVariable" },
            }
        end

        return original_entry
    end

    builtin.lsp_document_symbols(opts)
end

return M
