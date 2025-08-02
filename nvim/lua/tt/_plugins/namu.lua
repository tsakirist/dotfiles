local M = {}

function M.setup()
    require("namu").setup {
        namu_symbols = {
            enable = true,
            options = {
                display = {
                    format = "tree_guides",
                },
                window = {
                    title_prefix = require("tt.utils").pad(require("tt.icons").misc.ChevronRight),
                },
                AllowKinds = {
                    -- Filter symbols
                    default = {
                        "Class",
                        "Constructor",
                        "Enum",
                        "Field",
                        "Function",
                        "Interface",
                        "Method",
                        "Module",
                        "Namespace",
                        "Package",
                        "Property",
                        "Struct",
                        "Trait",
                    },
                },
                movement = {
                    next = { "<C-j>", "<Down>" },
                    previous = { "<C-k>", "<Up>" },
                    close = { "<C-q>", "<Esc>" },
                    select = { "<CR>" },
                    delete_word = { "<C-w>" },
                    clear_line = { "<C-l>" },
                },
            },
        },
        colorscheme = {
            enable = true,
            options = {
                title = "PAOKR",
                movement = {
                    next = { "<C-j>" },
                    previous = { "<C-k>" },
                    close = { "<C-q>" },
                },
            },
        },
    }

    local utils = require "tt.utils"
    utils.map("n", "<leader>fs", "<Cmd>Namu symbols<CR>", { desc = "Search for LSP document symbols" })
    utils.map("n", "<leader>fC", "<Cmd>Namu colorscheme<CR>", { desc = "List available colorschemes" })
end

return M
