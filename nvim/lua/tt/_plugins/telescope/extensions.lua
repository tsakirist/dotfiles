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
        results_ts_hl = true, -- Add treesitter highlighting to the results
    },
    fzf = {
        fuzzy = true, -- False will only do exact matching
        override_generic_sorter = true, -- Override the generic sorter
        override_file_sorter = true, -- Override the file sorter
        case_mode = "smart_case", -- "ignore_case" or "respect_case" or "smart_case"
    },
    grapple = {},
    ---@module "telescope._extensions.lazy"
    ---@type TelescopeLazy.Config
    lazy = {
        theme = "ivy",
    },
}

function M.setup()
    for _, extension in ipairs(vim.tbl_keys(M.extensions)) do
        require("telescope").load_extension(extension)
    end
end

return M
