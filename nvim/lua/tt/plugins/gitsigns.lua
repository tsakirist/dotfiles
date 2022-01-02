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
        watch_gitdir = { -- Add a watcher for the .git directory to detect changes
            interval = 1000, -- Interval to wait before polling gitdir in (ms)
            follow_files = true, -- Follow files e.g. git mv
        },
        attach_to_untracked = true, -- Attach to untracked files
        current_line_blame = false, -- Add current line blame
        current_line_blame_opts = { -- Options for lineblame
            virt_text = true, -- Whether to show virtual_text for line blame
            virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
            delay = 1000, -- Delay before line blame is shown
            ignore_whitespace = false, -- Ignore whitespaces
        },
        current_line_blame_formatter_opts = { -- Options for line-blame formatter
            relative_time = false,
        },
        sign_priority = 6, -- Sign priority
        update_debounce = 200, -- Debounce time for updates in (ms)
        status_formatter = nil, -- Use default status_formatter
        max_file_length = 40000, -- Max file length to attach to
        preview_config = { -- Options to pass to nvim_open_win
            border = "rounded",
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1,
        },
        keymaps = {
            noremap = true,
            buffer = true,

            -- Move between hunks
            ["n <leader>gj"] = {
                expr = true,
                "&diff ? ']c' : '<Cmd>Gitsigns next_hunk<CR>'",
            },
            ["n <leader>gk"] = {
                expr = true,
                "&diff ? '[c' : '<Cmd>Gitsigns prev_hunk<CR>'",
            },

            -- Hunk specific
            ["n <leader>hs"] = "<Cmd>Gitsigns stage_hunk<CR>",
            ["v <leader>hs"] = ":Gitsigns stage_hunk<CR>",
            ["n <leader>hu"] = "<Cmd>Gitsigns undo_stage_hunk<CR>",
            ["n <leader>hr"] = "<Cmd>Gitsigns reset_hunk<CR>",
            ["v <leader>hr"] = ":Gitsigns reset_hunk<CR>",
            ["n <leader>hR"] = "<Cmd>Gitsigns reset_buffer<CR>",
            ["n <leader>hp"] = "<Cmd>Gitsigns preview_hunk<CR>",
            ["n <leader>hb"] = "<Cmd>Gitsigns blame_line{full=true}<CR>",
            ["n <leader>hS"] = "<Cmd>Gitsigns stage_buffer<CR>",
            ["n <leader>hU"] = "<Cmd>Gitsigns reset_buffer_index<CR>",

            -- Toggling options
            ["n <leader>gb"] = "<Cmd>Gitsigns toggle_current_line_blame<CR>",
            ["n <leader>gh"] = "<Cmd>Gitsigns toggle_linehl<CR>",
            ["n <leader>gn"] = "<Cmd>Gitsigns toggle_numhl<CR>",
            ["n <leader>gs"] = "<Cmd>Gitsigns toggle_signs<CR>",
            ["n <leader>gw"] = "<Cmd>Gitsigns toggle_word_diff<CR>",

            -- Text objects
            ["o ih"] = ":<C-U>Gitsigns select_hunk()<CR>",
            ["x ih"] = ":<C-U>Gitsigns select_hunk()<CR>",
        },
    }
end

return M
