local utils = require "utils"

-- Toggle between folds
utils.map("n", "<F2>", "&foldlevel ? 'zM' : 'zR'", { expr = true })

-- Typing %% on the command line will expand to active buffer's path
vim.cmd "cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'"

-- Change buffers quickly
utils.map("n", "<leader>bn", "<Cmd>bnext<CR>")
utils.map("n", "<leader>bp", "<Cmd>bprevious<CR>")

utils.map("n", "<Tab>", "<Cmd>bnext<CR>")
utils.map("n", "<S-Tab>", "<Cmd>bprevious<CR>")

-- Close the current buffer
utils.map("n", "<leader>bd", "<Cmd>bdelete<CR>")

-- Close all buffers except the current one
utils.map("n", "<leader>bo", "<Cmd>%bd<Bar>e#")

-- List buffers and prepend :b on the cmd line
utils.map("n", "<leader>bf", "<Cmd>ls<CR><Cmd>b<Space>")

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
utils.map("n", "<C-S-Up>", "<Cmd>m-2<CR>==")
utils.map("n", "<C-S-Down>", "<Cmd>m+<CR>==")
utils.map("i", "<C-S-Up>", "<Esc><Cmd>m-2<CR>==gi")
utils.map("i", "<C-S-Down>", "<Esc><Cmd>m+<CR>==gi")
utils.map("v", "<C-S-Up>", "<Cmd>m '<-2<CR>gv=gv")
utils.map("v", "<C-S-Down>", "<Cmd>m '>+1<CR>gv=gv")

utils.map("n", "<C-k>", "<Cmd>m-2<CR>==")
utils.map("n", "<C-j>", "<Cmd>m+<CR>==")
utils.map("v", "<C-k>", "<Cmd>m '<-2<CR>gv=gv")
utils.map("v", "<C-j>", "<Cmd>m '>+1<CR>gv=gv")

utils.map("n", "<C-k>", "<Cmd>m-2<CR>==")
utils.map("n", "<C-j>", " <Cmd>m+<CR>==")
utils.map("v", "<C-k>", " <Cmd>m '<-2<CR>gv=gv")
utils.map("v", "<C-j>", " <Cmd>m '>+1<CR>gv=gv")

-- Duplicate the current line
-- 't' command is a synonym for copy
utils.map("n", "<leader>d", "<Cmd>t.<CR>")
utils.map("i", "<leader>d", "<Esc><Cmd>t.<CR>")
utils.map("v", "<leader>d", "<Cmd>t.<CR>")

-- Hitting ESC when inside a <Cmd>term to get into normal mode
utils.map("t", "<Esc>", [[<C-\><C-N>]])

-- Save files with ctrl+s
-- Use <Cmd>update instead of :write, to only write the file when modified
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

-- The '&' command repeats last substitution and the
-- second '&' keeps the previous flags that were used
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

-- utils.map("n", "<leader>z", "helper.zoomToggle()")
-- utils.map("n", "<leader>9", helper.trimTrailingWhiteSpace)

--[[

-- Command and key mapping to enable the zoom-in and zoom-out
command! ZoomToggle call functions#ZoomToggle()
utils.map("n", "<leader>z :ZoomToggle<CR>

-- Change the default mouse scrolling wheel options
utils.map("n", <ScrollWheelUp>   4<C-y>
utils.map("n", <ScrollWheelDown> 4<C-e>
xnoremap <ScrollWheelUp>   4<C-y>
xnoremap <ScrollWheelDown> 4<C-e>

-- Set a mark when moving more than 5 lines upwards/downards
-- this will populate the jumplist enabling us to jump back with Ctrl-O
utils.map("n", <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
utils.map("n", <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

-- Insert newlines below and above
utils.map("n", "<leader>o o<Esc>kO<Esc>j

-- Easiliy toggle comments
map  <leader><leader> gcc
vmap <leader><leader> gc
imap <leader><leader> <C-o><Cmd>lua require'Comment'.toggle()<CR>

-- Keybindings to toggle and kill the floating term window
utils.map("n", "<leader>ft :FloatermToggle<CR>
utils.map("n", "<leader>fk :FloatermKill<CR>
tnoremap "<leader>ft <C-\><C-n>:FloatermToggle<CR>
tnoremap "<leader>fk <C-\><C-n>:FloatermKill<CR>

-- Git-signify keybinds to use the plugin more easily
utils.map("n", "<leader>gh :SignifyToggleHighlight<CR>
utils.map("n", "<leader>gf :SignifyFold<CR>
utils.map("n", "<leader>gd :SignifyDiff<CR>
utils.map("n", "<leader>hd :SignifyHunkDiff<CR>
utils.map("n", "<leader>hu :SignifyHunkUndo<CR>

-- Git-signify jump between git diff hunks
nmap "<leader>gj <Plug>(signify-next-hunk)
nmap "<leader>gk <Plug>(signify-prev-hunk)
nmap "<leader>gJ 9999<leader>gj
nmap "<leader>gK 9999<leader>gk

-- Open git-messenger
nmap "<leader>gm <Plug>(git-messenger)

-- EasyAlign keybindings
-- 'vipga' starts interactive EasyAlign in visual mode
-- 'gaip' starts interactive EasyAlign for text/motion object
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
nmap <leader>ga <Plug>(LiveEasyAlign)
xmap <leader>ga <Plug>(LiveEasyAlign)

-- Use <Tab> and <S-Tab> to navigate through the autocomplete options
utils.map("i", "<expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
utils.map("i", "<expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

-- Alternate between header/source files
-- utils.map("n", "<leader>ko :Alternate<CR>
utils.map("n", "<leader>ko :ClangdSwitchSourceHeader<CR>

-- Git blame keybind toggle
utils.map("n", "<leader>gb :BlamerToggle<CR>

-- Also, '[q', ']q' work for cprev cnext, from vim-unimpaired
utils.map("n", "<leader>co :copen<CR>
utils.map("n", "<leader>cc :cclose<CR>
utils.map("n", "<leader>cr :cexpr []<CR>

-- Also '[l', ']l' work for lprev lnext, from vim-unimpaired
utils.map("n", "<leader>lo :lopen<CR>
utils.map("n", "<leader>lc :lclose<CR>
utils.map("n", "<leader>lr :lexpr []<CR>

-- Toggle quickfix and locationlist
utils.map("n", "<leader>ct :call functions#ToggleList('qf')<CR>
utils.map("n", "<leader>lt :call functions#ToggleList('loc')<CR>

-- Keybindings to toggle Vista and open Vista finder more easily
utils.map("n", "<leader>vv :Vista!!<CR>
utils.map("n", "<leader>vf :Vista finder nvim_lsp<CR>

-- Nvim-tree toggle keybinding
utils.map("n", "<leader>nt :NvimTreeToggle<CR>
utils.map("n", "<leader>nf :NvimTreeFindFile<CR> ]]
