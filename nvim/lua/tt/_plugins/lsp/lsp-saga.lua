local M = {}

function M.setup()
    local icons = require "tt.icons"

    require("lspsaga").setup {
        beacon = {
            enable = false,
        },
        symbol_in_winbar = {
            enable = false,
        },
        lightbulb = {
            sign = false,
            virtual_text = true,
        },
        diagnostic = {
            on_insert = false, -- Remove diagnostics on insert mode at the top right winbar
            text_hl_follow = true,
        },
        code_action = {
            extend_gitsigns = false,
            keys = {
                quit = { "<Esc> ", "q" },
                exec = "<CR>",
            },
        },
        definition = {
            edit = { "<C-o>", "<CR>" },
            split = "<C-x>",
            tabe = "<C-c>t",
            vsplit = "<C-v>",
            quit = { "<Esc>", "q" },
        },
        finder = {
            max_height = 0.7,
            keys = {
                split = "<C-x>",
                tabnew = "<C-t>",
                vsplit = "<C-v>",
                expand_or_jump = { "<CR>", "o" },
                quit = { "<Esc>", "q" },
            },
        },
        callhierarchy = {
            keys = {
                edit = "<C-o>",
                vsplit = "<C-v>",
                split = "<C-x>",
                tabe = "<C-t>",
                jump = { "<CR>", "o" },
                quit = { "<Esc>", "q" },
                expand_collapse = "u",
            },
        },
        rename = {
            quit = "<Esc>",
            exec = "<CR>",
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
    local function opts(desc)
        return { desc = desc, buffer = bufnr }
    end

    local utils = require "tt.utils"
    utils.map("n", "<leader>ca", "<Cmd>Lspsaga code_action<CR>", opts "Open code action menu")
    utils.map("n", "gd", "<Cmd>Lspsaga goto_definition<CR>", opts "Goto definition")
    utils.map("n", "gD", "<Cmd>Lspsaga goto_type_definition<CR>", opts "Goto type definition")
    utils.map("n", "gp", "<Cmd>Lspsaga peek_definition<CR>", opts "Peek definition")
    utils.map("n", "dA", "<Cmd>Lspsaga show_buf_diagnostics<CR>", opts "Show buffer diagnostics")
    utils.map("n", "do", "<Cmd>Lspsaga show_cursor_diagnostics<CR>", opts "Show cursor diagnostics")
    utils.map("n", "dn", "<Cmd>Lspsaga diagnostic_jump_next<CR>", opts "Jump to next diagnostic")
    utils.map("n", "dp", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", opts "Jump to previous diagnostic")
end

return M
