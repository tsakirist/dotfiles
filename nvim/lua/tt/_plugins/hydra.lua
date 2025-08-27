local M = {}

local Hydra = require "hydra"

local function setup_window_management_hydra()
    local hint = [[
^  ^^^^^^              ^^^^^^ ^ ^^^^ ^          ^^^ ^ ^ ^                ^
^  ^^^^^^     Move     ^^^^^^ ^ ^^^^  Resize   ^^^^ ^ ^     Split     ^  ^
^  ^^^^^^--------------^^^^^^ ^ ^^^^-----------^^^^ ^ ^---------------^  ^
^  ^ ^ _k_ ^ ^    ^ ^ _K_ ^ ^ ^ ^   ^ ^ _+_ ^ ^   ^ ^ _s_: horizontally  ^
^  _h_ ^ ^ _l_    _H_ ^ ^ _L_ ^ ^   _<_ ^ ^ _>_   ^ ^ _v_: vertically    ^
^  ^ ^ _j_ ^ ^    ^ ^ _J_ ^ ^ ^ ^   ^ ^ _-_ ^ ^   ^ ^ _q_: close         ^
^  ^^^^^^cursor  window^^^^^^ ^ ^^^_=_: equalize^^^ ^ _o_: only          ^
]]

    Hydra {
        name = "Window Management",
        hint = hint,
        config = {
            invoke_on_body = true,
            hint = {
                float_opts = {
                    border = "rounded",
                },
                offset = -1,
            },
        },
        mode = "n",
        body = "<leader>ww",
        heads = {
            -- Move cursor
            { "h", "<C-w>h" },
            { "j", "<C-w>j" },
            { "k", "<C-w>k" },
            { "l", "<C-w>l" },
            { "w", "<C-w>w", { exit = true, desc = false } },
            { "<C-w>", "<C-w>w", { exit = true, desc = false } },
            { "W", "<C-w>W", { exit = true, desc = false } },

            -- Move window
            { "H", "<C-w>H" },
            { "J", "<C-w>J" },
            { "K", "<C-w>K" },
            { "L", "<C-w>L" },

            -- Resize
            { "+", "<C-w>+" },
            { "-", "<C-w>-" },
            { "<", "<C-w><" },
            { ">", "<C-w>>" },
            { "=", "<C-w>=", { desc = "equalize" } },

            -- Split current
            { "s", "<C-w>s" },
            { "<C-s>", "<C-w><C-s>", { desc = false } },
            { "v", "<C-w>v" },
            { "<C-v>", "<C-w><C-v>", { desc = false } },
            { "x", "<C-w>s", { desc = false } },

            -- Split into tab
            { "T", "<C-w>T", { desc = false } },

            -- Close current
            { "q", "<C-w>q", { desc = "close" } },
            { "<C-q>", "<C-w>q", { desc = false } },

            -- Close others
            { "o", "<C-w>o", { exit = true, desc = "only" } },
            { "<C-o>", "<C-w>o", { exit = true, desc = false } },
        },
    }
end

local function setup_git_hydra()
    local gitsigns = require "gitsigns"

    local hint = [[
 _J_: next hunk      _s_: stage hunk        _r_: reset hunk     _b_: blame line
 _K_: prev hunk      _u_: undo stage hunk   _p_: preview hunk   _B_: blame show full
 _S_: stage buffer   _U_: unstage buffer    _R_: reset buffer   _d_: toggle deleted
 ^ ^
 ^ ^                            _q_: exit
]]

    Hydra {
        name = "Git",
        mode = { "n", "x" },
        body = "<leader>gg",
        hint = hint,
        config = {
            color = "pink",
            buffer = true,
            invoke_on_body = true,
            hint = {
                float_opts = {
                    border = "rounded",
                },
            },
            on_enter = function()
                vim.cmd.mkview()
                vim.cmd "silent! %foldopen!"
                vim.bo.modifiable = true
                gitsigns.toggle_signs(true)
                gitsigns.toggle_linehl(true)
            end,
            on_exit = function()
                local cursor_pos = vim.api.nvim_win_get_cursor(0)
                vim.cmd.loadview()
                vim.api.nvim_win_set_cursor(0, cursor_pos)
                vim.cmd.normal "zv"
                gitsigns.toggle_signs(false)
                gitsigns.toggle_linehl(false)
                gitsigns.preview_hunk_inline()
            end,
        },
        heads = {
            {
                "J",
                function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gitsigns.nav_hunk("next", { preview = true })
                    end)
                    return "<Ignore>"
                end,
                { expr = true, desc = "next hunk" },
            },
            {
                "K",
                function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gitsigns.nav_hunk("prev", { preview = true })
                    end)
                    return "<Ignore>"
                end,
                { expr = true, desc = "prev hunk" },
            },
            { "s", gitsigns.stage_hunk, { silent = true, desc = "stage hunk" } },
            { "r", gitsigns.reset_hunk, { silent = true, desc = "reset hunk" } },
            { "u", gitsigns.stage_hunk, { desc = "undo last stage" } },
            { "p", gitsigns.preview_hunk, { desc = "preview hunk" } },
            { "S", gitsigns.stage_buffer, { desc = "stage buffer" } },
            { "R", gitsigns.reset_buffer, { desc = "reset buffer" } },
            { "U", gitsigns.reset_buffer_index, { desc = "reset buffer index" } },
            { "d", gitsigns.preview_hunk_inline, { nowait = true, desc = "toggle deleted" } },
            { "b", gitsigns.blame_line, { desc = "blame" } },
            {
                "B",
                function()
                    gitsigns.blame_line { full = true }
                end,
                { desc = "blame show full" },
            },
            { "q", nil, { exit = true, nowait = true, desc = "exit" } },
        },
    }
end

local function setup_resize_mode()
    local smart_splits = require "smart-splits"

    Hydra {
        name = "Resize",
        mode = "n",
        body = "<leader>rs",
        config = { hint = false },
        heads = {
            { "h", smart_splits.resize_left, { desc = "Resize left" } },
            { "j", smart_splits.resize_down, { desc = "Resize down" } },
            { "k", smart_splits.resize_up, { desc = "Resize up" } },
            { "l", smart_splits.resize_right, { desc = "Resize right" } },
            { "<C-h>", smart_splits.move_cursor_left, { desc = "Move cursor left" } },
            { "<C-j>", smart_splits.move_cursor_down, { desc = "Move cursor down" } },
            { "<C-k>", smart_splits.move_cursor_up, { desc = "Move cursor up" } },
            { "<C-l>", smart_splits.move_cursor_right, { desc = "Move cursor right" } },
            { "q", nil, { exit = true, nowait = true, desc = "exit" } },
        },
    }
end

function M.setup()
    setup_window_management_hydra()
    setup_git_hydra()
    setup_resize_mode()
end

return M
