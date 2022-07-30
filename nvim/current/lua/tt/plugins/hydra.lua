local M = {}

local Hydra = require "hydra"

local function setup_venn_hydra()
    local hint = [[
 Arrow^^^^^^   Select region with <C-v>
 ^ ^
 ^ ^ _K_ ^ ^
 _H_ ^ ^ _L_   _B_: surround it with box
 ^ ^ _J_ ^ ^                   _q_: exit
]]

    Hydra {
        name = "Draw Diagram",
        mode = "n",
        body = "<leader>vt",
        hint = hint,
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = {
                border = "rounded",
            },
            on_enter = function()
                vim.cmd.setlocal "virtualedit=all"
            end,
            on_exit = function()
                vim.cmd.setlocal "virtualedit="
            end,
        },
        heads = {
            { "H", "<C-v>h:VBox<CR>" },
            { "J", "<C-v>j:VBox<CR>" },
            { "K", "<C-v>k:VBox<CR>" },
            { "L", "<C-v>l:VBox<CR>" },
            { "B", ":VBox<CR>", { mode = "v" } },
            { "q", nil, { exit = true, nowait = true, desc = "exit" } },
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
                border = "rounded",
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
                gitsigns.toggle_deleted(false)
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
                        gitsigns.next_hunk()
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
                        gitsigns.prev_hunk()
                    end)
                    return "<Ignore>"
                end,
                { expr = true, desc = "prev hunk" },
            },
            { "s", gitsigns.stage_hunk, { silent = true, desc = "stage hunk" } },
            { "r", gitsigns.reset_hunk, { silent = true, desc = "reset hunk" } },
            { "u", gitsigns.undo_stage_hunk, { desc = "undo last stage" } },
            { "p", gitsigns.preview_hunk, { desc = "preview hunk" } },
            { "S", gitsigns.stage_buffer, { desc = "stage buffer" } },
            { "R", gitsigns.reset_buffer, { desc = "reset buffer" } },
            { "U", gitsigns.reset_buffer_index, { desc = "reset buffer index" } },
            { "d", gitsigns.toggle_deleted, { nowait = true, desc = "toggle deleted" } },
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

function M.setup()
    setup_venn_hydra()
    setup_git_hydra()
end

return M
