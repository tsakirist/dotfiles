local utils = require "tt.utils"

-- Toggle between folds
utils.map("n", "<F2>", "&foldlevel ? 'zM' : 'zR'", { expr = true })

-- Typing %% on the command line will expand to active buffer's path
vim.cmd "cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'"

-- Change buffers quickly
utils.map("n", "]b", "<Cmd>bnext<CR>")
utils.map("n", "[b", "<Cmd>bprevious<CR>")
utils.map("n", "<Tab>", "<Cmd>bnext<CR>")
utils.map("n", "<S-Tab>", "<Cmd>bprevious<CR>")

-- Close the current buffer
utils.map("n", "<leader>bd", "<Cmd>bdelete<CR>")

-- Close all buffers except the current one
utils.map("n", "<leader>bo", "<Cmd>%bd<Bar>e#<CR>")

-- List buffers and prepend :b on the cmd line
utils.map("n", "<leader>bf", "<Cmd>ls<CR><Cmd>b<Space><CR>")

-- Search within buffers and send results in the qflist
vim.cmd "nnoremap <leader>bs :cex []<Bar>bufdo vimgrepadd //gj %<Bar>Trouble quickfix<S-Left><S-Left><S-Left><Right>"

-- Split comma separated arguments of function from one-line-all to one-line-each
-- f)%:       finds the starting '(' of the function signature
-- csbb:      changes surround blockwise from ( to ( on its own line
-- s/,/,\r/g: substitutes each ',' with ',' and carriage return '\r', one-arg-per-line
-- J:         joins the last ')' to the last argument
-- vib=:      select the surrounding text inside '()' and indent it visually
utils.map("n", "<leader>bp", "f)%cSbbj:s/,/,\r/g<CR>Jvib=<CR>")

-- Use space to toggle fold
utils.map("n", "<Space>", "za")

-- Keybinds to move lines up and down
utils.map("n", "<C-k>", ":m-2<CR>==")
utils.map("n", "<C-j>", ":m+<CR>==")
utils.map("v", "<C-k>", ":m '<-2<CR>gv=gv")
utils.map("v", "<C-j>", ":m '>+1<CR>gv=gv")

-- Duplicate the current line
-- 't' command is a synonym for copy
utils.map("n", "<leader>d", ":t.<CR>")
utils.map("i", "<leader>d", "<Esc>:t.<CR>")
utils.map("v", "<leader>d", ":t.<CR>")

-- Hitting ESC when inside a <Cmd>term to get into normal mode
utils.map("t", "<Esc>", [[<C-\><C-N>]])

-- Save files with ctrl+s
-- Use update instead of :write, to only write the file when modified
utils.map("n", "<C-s>", "<Cmd>update<CR>")
utils.map("i", "<C-s>", "<Esc><Cmd>update<CR>")
utils.map("v", "<C-s>", "<Esc><Cmd>update<CR>")

-- Keymaps to quit current buffer with ctrl+q
utils.map("n", "<C-q>", "<Cmd>q<CR>")
utils.map("i", "<C-q>", "<Esc><Cmd>q<CR>")
utils.map("v", "<C-q>", "<Esc><Cmd>q<CR>")

-- Keymaps to quit current buffer with ctrl+q
utils.map("n", "<C-q>", "<Cmd>q<CR>")
utils.map("i", "<C-q>", "<Esc><Cmd>q<CR>")
utils.map("v", "<C-q>", "<Esc><Cmd>q<CR>")

-- Keymap to quit all buffers with shift
utils.map("n", "Q", "<Esc><Cmd>qa<CR>")

-- Quick movements in Insert mode without having to change to Normal mode
utils.map("i", "<C-h>", "<C-o>h")
utils.map("i", "<C-l>", "<C-o>l")
utils.map("i", "<C-j>", "<C-o>j")
utils.map("i", "<C-k>", "<C-o>k")
utils.map("i", "<C-b>", "<C-o>B")
utils.map("i", "<C-e>", "<C-o>E<C-o>l")
utils.map("i", "<C-a>", "<C-o>A")
utils.map("i", "<C-^>", "<C-o><C-^>")

-- Keep Visual mode selection when indenting text
utils.map("x", ">", ">gv")
utils.map("x", "<", "<gv")

-- Make visual pasting a word to not update the unnamed register
-- Thus, allowing us to repeatedly paste the word. {"_ : black-hole register}
utils.map("v", "p", [["_dP]])

-- The '&' command repeats last substitution and the second '&' keeps the previous flags that were used
-- So, usually we want to have this as the default behavior
utils.map("n", "&", "<Cmd>&&<CR>")
utils.map("x", "&", "<Cmd>&&<CR>")

-- Remind myself to stop using the god damn arrow keys
utils.map("n", "<Left>", "<Cmd>echoe 'Use h'<CR>")
utils.map("n", "<Right>", "<Cmd>echoe 'Use l'<CR>")
utils.map("n", "<Up>", "<Cmd>echoe 'Use k'<CR>")
utils.map("n", "<Down>", "<Cmd>echoe 'Use j'<CR>")
utils.map("v", "<Left>", "<Cmd><C-u>echoe 'Use h'<CR>")
utils.map("v", "<Right>", "<Cmd><C-u>echoe 'Use l'<CR>")
utils.map("v", "<Up>", "<Cmd><C-u>echoe 'Use k'<CR>")
utils.map("v", "<Down>", "<Cmd><C-u>echoe 'Use j'<CR>")

-- Clear highlighting with escape when in normal mode
-- https://stackoverflow.com/a/1037182/6654329
utils.map("n", "<Esc>", "<Cmd>noh<return><Esc>")
utils.map("n", "<Esc>^[", "<Esc>^[")

-- Keymaps to open terminal either horiznotally or vertically
utils.map("n", "<leader>ht", "<Cmd>HT<CR>")
utils.map("n", "<leader>vt", "<Cmd>VT<CR>")

-- Whole-word search
vim.cmd [[nnoremap <leader>/ :/\<\><Left><Left>]]

-- Change the default mouse scrolling wheel option
utils.map("n", "<ScrollWheelUp>", "4<C-y>")
utils.map("n", "<ScrollWheelDown>", "4<C-e>")
utils.map("x", "<ScrollWheelUp>", "4<C-y>")
utils.map("x", "<ScrollWheelDown>", "4<C-e>")

-- Set a mark when moving more than 5 lines upwards/downards
-- this will populate the jumplist enabling us to jump back with Ctrl-O
utils.map("n", "k", [[(v:count > 5 ? "m'" . v:count : "") . 'k']], { expr = true })
utils.map("n", "j", [[(v:count > 5 ? "m'" . v:count : "") . 'j']], { expr = true })

-- Insert newlines below and above
utils.map("n", "<leader>o", "o<Esc>kO<Esc>j")

-- EasyAlign keybindings
-- 'vipga' starts interactive EasyAlign in visual mode
-- 'gaip' starts interactive EasyAlign for text/motion object
utils.map("n", "ga", "<Plug>(EasyAlign)", { noremap = false })
utils.map("x", "ga", "<Plug>(EasyAlign)", { noremap = false })
utils.map("n", "<leader>ga", "<Plug>(LiveEasyAlign)", { noremap = false })
utils.map("x", "<leader>ga", "<Plug>(LiveEasyAlign)", { noremap = false })

-- Alternate between header/source files
-- TODO: move this to lspconfig?
utils.map("n", "<leader>ko", "<Cmd>ClangdSwitchSourceHeader<CR>")
