local M = {}

function M.setup()
    require("nvim-surround").setup {
        keymaps = {
            insert = "<C-g>s",
            insert_line = "<C-g>S",
            normal = "ys",
            normal_cur = "yss",
            normal_line = "yS",
            normal_cur_line = "ySS",
            visual = "S",
            visual_line = "gS",
            delete = "ds",
            change = "cs",
        },
        aliases = {
            ["a"] = ">",
            ["b"] = ")",
            ["B"] = "}",
            ["r"] = "]",
            ["q"] = { '"', "'", "`" },
            ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
        },
        --  If the value is zeero the highlights persist until the surround action is completed
        highlight = {
            duration = 0,
        },
        -- Move cursor to the beginning after operation
        move_cursor = "begin",
    }
end

return M
