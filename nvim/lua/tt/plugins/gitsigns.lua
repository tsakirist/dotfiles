local M = {}

function M.setup()
    require("gitsigns").setup {
        signs = {
            add = {
                text = "│",
                hl = "GitSignsAdd",
                numhl = "GitSignsAddNr",
                linehl = "GitSignsAddLn",
            },
            change = {
                text = "│",
                hl = "GitSignsChange",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn",
            },
            delete = {
                text = "-",
                hl = "GitSignsDelete",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn",
            },
            topdelete = {
                text = "‾",
                hl = "GitSignsDelete",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn",
            },
            changedelete = {
                text = "~",
                hl = "GitSignsChange",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn",
            },
        },
        signcolumn = true, -- Add signs in the signcolumn
        numhl = true, -- Highlights just the number part of the number column
        linehl = false, -- Highlights the whole line
        word_diff = false, -- Highlights just the part of the line that has changed
        watch_gitdir = {
            interval = 1000,
            follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
            delay = 1000,
        },
        current_line_blame_formatter_opts = {
            relative_time = false,
        },
        sign_priority = 6,
        update_debounce = 200,
        status_formatter = nil,
        max_file_length = 40000,
        preview_config = { -- Options passed to nvim_open_win
            border = "rounded",
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1,
        },
        keymaps = {
            -- Default keymap options
            noremap = true,
            buffer = true,

            -- Move between hunks
            ["n <leader>gj"] = {
                expr = true,
                "&diff ? ']c' : '<Cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'",
            },
            ["n <leader>gk"] = {
                expr = true,
                "&diff ? '[c' : '<Cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'",
            },

            -- Hunk specific
            ["n <leader>hs"] = "<Cmd>lua require'gitsigns'.stage_hunk()<CR>",
            ["v <leader>hs"] = "<Cmd>lua require'gitsigns'.stage_hunk({vim.fn.line('.'), vim.fn.line('v')})<CR>",
            ["n <leader>hu"] = "<Cmd>lua require'gitsigns'.undo_stage_hunk()<CR>",
            ["n <leader>hr"] = "<Cmd>lua require'gitsigns'.reset_hunk()<CR>",
            ["v <leader>hr"] = "<Cmd>lua require'gitsigns'.reset_hunk({vim.fn.line('.'), vim.fn.line('v')})<CR>",
            ["n <leader>hp"] = "<Cmd>lua require'gitsigns'.preview_hunk()<CR>",
            ["n <leader>hb"] = "<Cmd>lua require'gitsigns'.blame_line{full=true}<CR>",
            ["n <leader>hS"] = "<Cmd>lua require'gitsigns'.stage_buffer()<CR>",
            ["n <leader>hU"] = "<Cmd>lua require'gitsigns'.reset_buffer_index()<CR>",

            -- Toggling options
            ["n <leader>gb"] = "<Cmd>Gitsigns toggle_current_line_blame<CR>",
            ["n <leader>gh"] = "<Cmd>Gitsigns toggle_linehl<CR>",
            ["n <leader>gn"] = "<Cmd>Gitsigns toggle_numhl<CR>",
            ["n <leader>gs"] = "<Cmd>Gitsigns toggle_signs<CR>",
            ["n <leader>gw"] = "<Cmd>Gitsigns toggle_word_diff<CR>",

            -- Text objects
            ["o ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
            ["x ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
        },
    }
end

return M
