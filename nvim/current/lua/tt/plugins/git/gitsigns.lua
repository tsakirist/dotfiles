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
        show_deleted = false, -- Show deleted hunks with virtual text
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
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>", -- Line blame formatter
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
        -- Setup keymappings
        on_attach = function(bufnr)
            local gitsigns = package.loaded.gitsigns

            local function map(mode, lhs, rhs, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, lhs, rhs, opts)
            end

            local function visual_operation(operator)
                return function()
                    return require("gitsigns")[operator] { vim.fn.line "v", vim.fn.line "." }
                end
            end

            -- Move between hunks
            map("n", "<leader>gj", function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    gitsigns.next_hunk()
                end)
                return "<Ignore>"
            end, { expr = true, desc = "Next hunk" })

            map("n", "<leader>gk", function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    gitsigns.prev_hunk()
                end)
                return "<Ignore>"
            end, { expr = true, desc = "Previous hunk" })

            -- Hunk specific
            map("n", "<leader>hs", gitsigns.stage_hunk)
            map("n", "<leader>hr", gitsigns.reset_hunk)
            map("n", "<leader>hu", gitsigns.undo_stage_hunk)
            map("n", "<leader>hp", gitsigns.preview_hunk)
            map("n", "<leader>hb", gitsigns.blame_line)

            -- Buffer specific
            map("n", "<leader>hS", gitsigns.stage_buffer)
            map("n", "<leader>hR", gitsigns.reset_buffer)
            map("n", "<leader>hU", gitsigns.reset_buffer_index)
            map("n", ",leader>hD", function()
                gitsigns.diffthis "~"
            end)

            -- Toggling options
            map("n", "<leader>gb", gitsigns.toggle_current_line_blame)
            map("n", "<leader>gh", gitsigns.toggle_linehl)
            map("n", "<leader>gn", gitsigns.toggle_numhl)
            map("n", "<leader>gs", gitsigns.toggle_signs)
            map("n", "<leader>gw", gitsigns.toggle_word_diff)
            map("n", "<leader>gd", gitsigns.toggle_deleted)

            -- Text objects
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")

            -- Stage/unstage/reset visually selected partial hunks
            map("v", "<leader>hs", visual_operation "stage_hunk", {
                desc = "Gitsigns stage selected hunk(s)",
            })
            map("v", "<leader>hu", visual_operation "undo_stage_hunk", {
                desc = "Gitsigns undo stage selected hunk(s)",
            })
            map("v", "<leader>hr", visual_operation "reset_hunk", {
                desc = "Gitsigns reset selected hunk(s)",
            })
        end,
    }
end

return M
