local M = {}

function M.setup()
    require("spectre").setup {
        color_devicons = true, -- Use icons
        is_insert_mode = true, -- Start open panel in insert mode
        live_update = true, -- Auto execute search again when a file is written
        line_sep_start = "┌──────────────────────────────────────────",
        result_padding = "│  ",
        line_sep = "└───────────────────────────────────────────",
        highlight = {
            ui = "String",
            search = "GitSignsDeleteInline",
            replace = "GitSignsAddInline",
        },
        mapping = {
            ["toggle_symlinks"] = {
                map = "tl",
                cmd = "<Cmd>lua require('spectre').change_options('symlink')<CR>",
                desc = "toggle symlink",
            },
            ["run_replace"] = {
                map = "<leader>ra",
                cmd = "<Cmd>lua require('spectre.actions').run_replace()<CR>",
                desc = "replace all",
            },
        },
        find_engine = {
            ["rg"] = {
                options = {
                    ["symlink"] = {
                        value = "--follow",
                        icon = "[L]",
                        desc = "symlinks",
                    },
                },
            },
        },
        default = {
            find = {
                cmd = "rg",
                options = { "ignore-case", "symlink" },
            },
        },
    }

    local utils = require "tt.utils"
    utils.map("n", "<leader>sr", function()
        require("spectre").open()
    end, { desc = "Search and replace files with Spectre" })

    utils.map("n", "<leader>sf", function()
        require("spectre").open_file_search()
    end, { desc = "Search and reaplce in current file with Spectre" })

    utils.map("n", "<leader>sw", function()
        require("spectre").open_visual { is_insert_mode = false, select_word = true }
    end, { desc = "Search and replace for current word with Spectre" })
end

return M
