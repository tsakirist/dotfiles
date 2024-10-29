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
            o = "jump",
            ["<C-x>"] = "jump_split",
            ["<C-v>"] = "jump_vsplit",
            ["<Space>"] = "fold_toggle",
            ["<CR>"] = "jump_close",
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
            diagnostics_inline_preview_buffer = {
                mode = "diagnostics",
                preview = {
                    type = "split",
                    relative = "win",
                    position = "right",
                    size = 0.4,
                },
                filter = {
                    buf = 0,
                },
            },
            lsp_document_symbols_float = {
                mode = "lsp_document_symbols",
                win = {
                    type = "float",
                    relative = "editor",
                    border = "rounded",
                    title = "LSP document symbols",
                    title_pos = "center",
                    size = {
                        width = 0.7,
                        height = 0.7,
                    },
                },
            },
            lsp_references = {
                preview = {
                    type = "float",
                    relative = "win",
                    border = "rounded",
                    title = "LSP reference preview",
                    title_pos = "center",
                    size = {
                        height = 1,
                        width = 0.5,
                    },
                    position = { 0, 1 },
                },
            },
        },
    }

    -- stylua: ignore start
    local utils = require "tt.utils"
    utils.map("n", "<leader>td", "<Cmd>Trouble diagnostics_inline_preview toggle<CR>", { desc = "Trouble diagnostics" })
    utils.map("n", "<leader>tD", "<Cmd>Trouble diagnostics_inline_preview_buffer toggle<CR>", { desc = "Trouble diagnostics for current buffer" })
    utils.map("n", "<leader>tl", "<Cmd>Trouble loclist toggle<CR>", { desc = "Trouble loclist" })
    utils.map("n", "<leader>tq", "<Cmd>Trouble quickfix toggle<CR>", { desc = "Trouble quickfix" })
    utils.map("n", "<leader>tr", "<Cmd>Trouble lsp_references toggle<CR>", { desc = "Trouble lsp references" })
    utils.map("n", "<leader>ti", "<Cmd>Trouble lsp_implementations toggle<CR>", { desc = "Trouble lsp implementations" })
    utils.map("n", "<leader>ts", "<Cmd>Trouble lsp_document_symbols_float toggle<CR>", { desc = "Trouble lsp document symbols float" })
    -- stylua: ignore end
end

return M
