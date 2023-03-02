local M = {}

function M.setup()
    local icons = require "tt.icons"

    require("lspsaga").setup {
        symbol_in_winbar = {
            enable = false,
        },
        lightbulb = {
            virtual_text = false,
        },
        code_action = {
            extend_gitsigns = false,
        },
        defintion = {
            split = "<C-c>x",
        },
        diagnostic = {
            on_insert = false, -- Remove diagnostics on insert mode at the top right winbar
            text_hl_follow = true,
        },
        finder = {
            max_height = 0.7,
        },
        ui = {
            title = true,
            border = "rounded",
            winblend = 5,
            expand = icons.misc.ArrowColappsed,
            collapse = icons.misc.ArrowExpanded,
            preview = icons.misc.Preview,
            code_action = icons.misc.BulbColored,
            diagnostic = icons.misc.Bug,
            incoming = icons.misc.CallIncoming,
            outgoing = icons.misc.CallOutgoing,
            hover = icons.misc.AlignRight,
        },
    }
end

function M.on_attach(_, bufnr)
    -- stylua: ignore start
    local utils = require "tt.utils"
    utils.map("n", "db", "<Cmd>Lspsaga show_buf_diagnostics<CR>", { buffer = bufnr, desc = "Show buffer diagnostics" })
    utils.map("n", "do", "<Cmd>Lspsaga show_cursor_diagnostics<CR>", { buffer = bufnr, desc = "Show cursor diagnostics" })
    utils.map("n", "dn", "<Cmd>Lspsaga diagnostic_jump_next<CR>", { buffer = bufnr, desc = "Jump to next diagnostic" })
    utils.map("n", "dp", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", { buffer = bufnr, desc = "Jump to previous diagnostic" })
    utils.map("n", "gp", "<Cmd>Lspsaga peek_definition<CR>", { buffer = bufnr, desc = "Peek definition" })
    utils.map("n", "gr", "<Cmd>Lspsaga lsp_finder<CR>", { buffer = bufnr, desc = "Find definition and references of current symbol" })
    utils.map("n", "K", "<Cmd>Lspsaga hover_doc<CR>", { buffer = bufnr, desc = "Show information of current symbol" })
    utils.map("n", "<leader>ca", "<Cmd>Lspsaga code_action<CR>", { buffer = bufnr, desc = "Open code action menu" })
    utils.map("n", "<leader>ic", "<Cmd>Lspsaga incoming_calls<CR>", { buffer = bufnr, desc = "Show incoming calls" })
    utils.map("n", "<leader>oc", "<Cmd>Lspsaga outgoing_calls<CR>", { buffer = bufnr, desc = "Show outgoing calls" })
end

return M
