local M = {}

function M.setup()
    require("trouble").setup {
        auto_close = false, -- Auto close when there are no items
        auto_preview = true, -- Automatically open preview when on an item
        auto_refresh = true, -- Auto refresh when open
        auto_jump = false, -- Auto jump to the item when there's only one
        focus = true, -- Focus the window when opened
        restore = true, -- Restores the last location in the list when opening
        follow = true, -- Follow the current item
        indent_guides = true, -- Show indent guides
        warn_no_results = true, -- Show a warning when there are no results
        open_no_results = true, -- Open the trouble window when there are no results
        keys = {
            q = "close",
            go = "jump_close",
            ["<C-x>"] = "jump_split",
            ["<C-v>"] = "jump_vsplit",
            ["<Space>"] = "fold_toggle",
        },
        win = {
            type = "split",
            position = "bottom",
            size = {
                height = 18,
            },
        },
        modes = {
            diagnostics_inline_preview = {
                mode = "diagnostics",
                preview = {
                    type = "split",
                    relative = "win",
                    position = "right",
                    size = 0.4,
                },
            },
        },
    }

    local utils = require "tt.utils"
    utils.map("n", "<leader>td", "<Cmd>Trouble diagnostics_inline_preview<CR>")
    utils.map("n", "<leader>tl", "<Cmd>Trouble loclist<CR>")
    utils.map("n", "<leader>tq", "<Cmd>Trouble quickfix<CR>")
    utils.map("n", "<leader>tr", "<Cmd>Trouble lsp_references<CR>")
    utils.map("n", "<leader>ti", "<Cmd>Trouble lsp_implementations<CR>")
end

return M
