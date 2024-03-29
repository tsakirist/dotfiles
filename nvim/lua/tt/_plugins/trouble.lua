local M = {}

function M.setup()
    local icons = require "tt.icons"

    require("trouble").setup {
        position = "bottom", -- position of the list can be: bottom, top, left, right
        height = 18, -- height of the trouble list when position is top or bottom
        width = 50, -- width of the list when position is left or right
        icons = true, -- use devicons for filenames
        mode = "document_diagnostics", -- "lsp_workspace_diagnostics", "quickfix", "lsp_references", "loclist"
        fold_open = "", -- icon used for open folds
        fold_closed = "", -- icon used for closed folds
        group = true, -- groupe results by file
        padding = true, -- add an extra new line on top of the list
        action_keys = { -- key mappings for actions in the trouble list
            close = "q", -- close the list
            cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
            refresh = "r", -- manually refresh
            jump = { "<cr>", "<tab>", "o" }, -- jump to the diagnostic or open / close folds
            jump_close = { "go" }, -- jump to the diagnostic and close the list
            open_split = { "<c-x>" }, -- open buffer in new split
            open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
            open_tab = { "<c-t>" }, -- open buffer in new tab
            toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
            toggle_preview = "P", -- toggle auto_preview
            hover = "K", -- opens a small poup with the full multiline message
            preview = "p", -- preview the diagnostic location
            close_folds = { "zM", "zm" }, -- close all folds
            open_folds = { "zR", "zr" }, -- open all folds
            toggle_fold = { "<Space>", "za" }, -- toggle fold of current file
            previous = "<C-k>", -- previous item
            next = "<C-j>", -- next item
        },
        indent_lines = true, -- add an indent guide below the fold icons
        auto_open = false, -- automatically open the list when you have diagnostics
        auto_close = false, -- automatically close the list when you have no diagnostics
        auto_preview = true, -- automatically preview the location of the diagnostic
        auto_fold = false, -- automatically fold a file trouble list at creation
        auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
        signs = {
            error = icons.diagnostics.Error,
            information = icons.diagnostics.Info,
            warning = icons.diagnostics.Warn,
            hint = icons.diagnostics.Hint,
        },
        use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
    }

    local utils = require "tt.utils"
    utils.map("n", "<leader>td", "<Cmd>TroubleToggle document_diagnostics<CR>")
    utils.map("n", "<leader>tl", "<Cmd>TroubleToggle loclist<CR>")
    utils.map("n", "<leader>tq", "<Cmd>TroubleToggle quickfix<CR>")
    utils.map("n", "<leader>tr", "<Cmd>TroubleToggle lsp_references<CR>")
    utils.map("n", "<leader>tw", "<Cmd>TroubleToggle lsp_implementations<CR>")
    utils.map("n", "<leader>tw", "<Cmd>TroubleToggle workspace_diagnostics<CR>")
end

return M
