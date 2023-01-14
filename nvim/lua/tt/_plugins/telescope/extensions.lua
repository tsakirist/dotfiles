local actions = require "telescope.actions"
local lga_actions = require "telescope-live-grep-args.actions"

local M = {}

M.extensions = {
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
    notify = {},
}

function M.setup()
    for _, extension in ipairs(vim.tbl_keys(M.extensions)) do
        require("telescope").load_extension(extension)
    end
end

return M
