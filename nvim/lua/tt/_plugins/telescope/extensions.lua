local actions = require "telescope.actions"

local M = {}

M.extensions = {
    egrepify = {
        permutations = true,
        prefixes = {
            -- Partial file name filtering
            ["*"] = {
                flag = "glob",
                cb = function(input)
                    return string.format("*{%s}*", input)
                end,
            },
            -- Partial directory name filtering
            ["**"] = {
                flag = "glob",
                cb = function(input)
                    return string.format("**/{%s}/**", input)
                end,
            },
            -- Disable default prefixes
            [">"] = false,
            ["&"] = false,
        },
    },
    fzf = {
        fuzzy = true, -- False will only do exact matching
        override_generic_sorter = true, -- Override the generic sorter
        override_file_sorter = true, -- Override the file sorter
        case_mode = "smart_case", -- "ignore_case" or "respect_case" or "smart_case"
    },
    lazy = {
        theme = "ivy",
    },
    notify = {},
}

function M.setup()
    for _, extension in ipairs(vim.tbl_keys(M.extensions)) do
        require("telescope").load_extension(extension)
    end
end

return M
