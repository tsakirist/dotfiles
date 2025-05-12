local utils = require "tt.utils"
local helper = require "tt.helper"

-- Typing %% on the command line will expand to active buffer's path
utils.map("c", "%%", "getcmdtype() == ':' ? expand('%:h').'/' : '%%'", { silent = false, expr = true })

-- Change buffers quickly
utils.map("n", "]b", "<Cmd>bnext<CR>")
utils.map("n", "[b", "<Cmd>bprevious<CR>")
utils.map("n", "<Tab>", "<Cmd>bnext<CR>")
utils.map("n", "<S-Tab>", "<Cmd>bprevious<CR>")

-- Close all buffers except the current one and also keep cursor position intact
utils.map("n", "<leader>bo", function()
    local cmd = "%bd|e#|bd#"
    helper.preserve_cursor_position(cmd)
end, { desc = "Keep only the current buffer open" })

-- List buffers and open them either on the same window or another
utils.map("n", "<leader>bf", ":ls<CR>:b<Space>", { silent = false })
utils.map("n", "<leader>bs", ":ls<CR>:sb<Space>", { silent = false })
utils.map("n", "<leader>bv", ":ls<CR>:vert sb<Space>", { silent = false })

-- Search within buffers and send results in the qflist
utils.map(
    "n",
    "<leader>bS",
    ":cex []<Bar>bufdo vimgrepadd //gj %<Bar>Trouble quickfix<S-Left><S-Left><S-Left><Right>",
    { silent = false }
)

-- Toggle comment lines using native 'gcc' mapping
utils.map("n", "<leader><leader>", "gcc", { remap = true, desc = "Toggle comment" })
utils.map("i", "<leader><leader>", "<C-o>gcc", { remap = true, desc = "Toggle comment" })
utils.map("v", "<leader><leader>", "gc", { remap = true, desc = "Toggle comment" })

-- Use space to toggle fold
utils.map("n", "<Space>", "za")

-- Duplicate the current line or lines
utils.map("n", "<leader>d", ":t.<CR>")
utils.map("i", "<leader>d", "<Esc>:t.<CR>")
utils.map("v", "<leader>d", function()
    local visual_selection = helper.get_visual_selection()
    local lines = vim.api.nvim_buf_get_lines(0, visual_selection.start_pos - 1, visual_selection.end_pos, true)
    vim.api.nvim_buf_set_lines(0, visual_selection.end_pos, visual_selection.end_pos, true, lines)
end)

-- Save files with ctrl+s
-- Use update instead of :write, to only write the file when modified
utils.map("n", "<C-s>", "<Cmd>update<CR>")
utils.map({ "i", "v" }, "<C-s>", "<Esc><Cmd>update<CR>")

-- Keymaps to quit current buffer with ctrl+q
utils.map({ "n", "i", "v" }, "<C-q>", "<Esc>:q<CR>", { desc = "Quit current window" })

-- Keymap to quit all buffers
utils.map("n", "Q", "<Esc><Cmd>qa!<CR>")

-- Quick movements in Insert mode without having to change to Normal mode
utils.map("i", "<C-h>", "<Left>", { desc = "Move left" })
utils.map("i", "<C-l>", "<Right>", { desc = "Move right" })
utils.map("i", "<C-j>", "<Down>", { desc = "Move down" })
utils.map("i", "<C-k>", "<Up>", { desc = "Move up" })
utils.map("i", "<C-0>", "<C-o>^", { desc = "Move to the first non-blank at the beginning" })
utils.map("i", "<C-a>", "<End>", { desc = "Move to the end" })
utils.map("i", "<C-b>", "<C-o>B", { desc = "Move a WORD backwards" })
utils.map("i", "<C-e>", "<C-o>E<C-o>l", { desc = "Move a WORD forward" })

-- Keep Visual mode selection when indenting text
utils.map("x", ">", ">gv")
utils.map("x", "<", "<gv")

-- Make visual pasting a word to not update the unnamed register
-- Thus, allowing us to repeatedly paste the word. {"_ : black-hole register}
utils.map("v", "p", [["_dP]])

-- Paste before and after the current line
utils.map("n", "[p", function()
    vim.cmd.put { bang = true }
end, { desc = "Paste before line" })

utils.map("n", "]p", function()
    vim.cmd.put {}
end, { desc = "Paste after line" })

-- The '&' command repeats last substitution and the second '&' keeps the previous flags that were used
-- So, usually we want to have this as the default behavior
utils.map("n", "&", "<Cmd>&&<CR>")
utils.map("x", "&", "<Cmd>&&<CR>")

-- Remind myself to stop using the god damn arrow keys
utils.map({ "n", "v" }, "<Left>", "<Cmd>echoe 'Use h'<CR>")
utils.map({ "n", "v" }, "<Right>", "<Cmd>echoe 'Use l'<CR>")
utils.map({ "n", "v" }, "<Up>", "<Cmd>echoe 'Use k'<CR>")
utils.map({ "n", "v" }, "<Down>", "<Cmd>echoe 'Use j'<CR>")

-- Clear highlighting with escape when in normal mode
-- https://stackoverflow.com/a/1037182/6654329
utils.map("n", "<Esc>", "<Cmd>noh<CR><Esc>")
utils.map("n", "<Esc>^[", "<Esc>^[")

-- Whole-word search
utils.map("n", "<leader>/", ":/\\<\\><Left><Left>", { silent = false })

-- Change the default mouse scrolling wheel option
utils.map({ "n", "x" }, "<ScrollWheelUp>", "4<C-y>")
utils.map({ "n", "x" }, "<ScrollWheelDown>", "4<C-e>")

-- Set a mark when moving more than 5 lines upwards/downards
-- this will populate the jumplist enabling us to jump back with Ctrl-O
utils.map("n", "k", [[(v:count > 5 ? "m'" . v:count : "") . 'k']], { expr = true })
utils.map("n", "j", [[(v:count > 5 ? "m'" . v:count : "") . 'j']], { expr = true })

-- Insert newlines below and above
utils.map("n", "<leader>o", "o<Esc>kO<Esc>j")

-- Zoom toggle a buffer in a new tab
utils.map("n", "<leader>z", function()
    helper.zoom_toggle_new_tab()
end, { desc = "Zoom toggle a buffer in a new tab" })

-- Make `n|N` to also center the screen and open any folds
utils.map("n", "n", "nzzzv")
utils.map("n", "N", "Nzzzv")

-- Make the scrolling actions to also center the screen
utils.map("n", "<C-f>", "<C-f>zz")
utils.map("n", "<C-b>", "<C-b>zz")

-- Sort visual selection
utils.map("v", "<leader>s", ":sort<CR>", { desc = "Sort visual selection" })

-- Sort inner blocks
utils.map("n", "<leader>sb", "vib:sort<CR>", { desc = "Sort '() inner block" })
utils.map("n", "<leader>sB", "viB:sort<CR>", { desc = "Sort '{}' inner block" })

-- Paste until EOL from current cursor position
utils.map("n", "<M-p>", [[vg_"_dp]], { desc = "Paste from current cursor position until EOL" })

-- Search in the visual selected area
utils.map("v", "/", [[<Esc>/\%V]], { silent = false, desc = "Search within visual selected area" })

-- Copy the absolute filename to the clipboard
utils.map("n", "<leader>cp", function()
    helper.copy_filename_to_clipboard "p"
end, { desc = "Copy absolute path of file to clipboard" })

-- Copy the filename after applying the filename-modifer from ui.input
utils.map("n", "<leader>cP", function()
    vim.ui.input({ prompt = "Enter filename modifier: ", default = "p" }, function(input)
        if input then
            helper.copy_filename_to_clipboard(input)
        end
    end)
end, { desc = "Copy current filename according to the supplied modifier" })
