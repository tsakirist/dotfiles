local M = {}

function M.setup()
    require("mini.surround").setup {
        custom_surroundings = {
            ["B"] = {
                input = { "%b{}", "^.().*().$" },
                output = { left = "{", right = "}" },
            },
        },
        mappings = {
            add = "ys",
            delete = "ds",
            highlight = "gs",
            replace = "cs",
            find = "",
            find_left = "",
            update_n_lines = "",
            suffix_last = "",
            suffix_next = "",
        },
        search_method = "cover_or_next",
        highlight_duration = 2000,
    }

    -- Delete mapping added from `mini-surround`
    vim.keymap.del("x", "ys")

    local utils = require "tt.utils"
    utils.map("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { desc = "Add surrounding" })
    utils.map("n", "yss", "ys_", { desc = "Add surrounding for line", remap = true })
end

return M
