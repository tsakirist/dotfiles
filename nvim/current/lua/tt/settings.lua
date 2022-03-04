local opt = vim.opt

-- Syntax highlighting
opt.syntax = "on"

-- No compatible
opt.compatible = false

-- Set true colors inside nvim
opt.termguicolors = true

-- Don't show the (INSERT, REPLACE, VISUAL) modes on the last line
opt.showmode = false

-- Highlight the current line and also highlight the column @120 (ruler)
-- o.colorcolumn = 120
opt.cursorline = true

-- Set hidden to on so as to be able to change buffers without saving first
opt.hidden = true

-- Set hybrid line numbers
opt.number = true
opt.relativenumber = true

-- Set the number of columns used for line numbers
opt.numberwidth = 1

-- Insert spaces when <Tab> is pressed
opt.expandtab = true

-- Controls the number of space characters inserted when pressing the tab key
opt.tabstop = 4

-- Controls the number of space characters inserted for identation
opt.shiftwidth = 4

-- Use the indentation level of the previous line when pressing enter
opt.autoindent = true

-- Enable automatic C/C++ program indenting with the following options:
-- NOTE: These options will only apply when `cindent` is on, happens automatically for C-like files
-- gN: sets the indentation of scope declarations like public, private, protected
-- :N: sets the indentation for case labels inside switch statements
-- lN: align with a case label instead of the statement after it in the same line
-- NN: sets the indentation of content inside namespaces
-- (N: sets the indentation when in unclosed parentheses to line up vertically
-- wN: when in unclosed parentheses line up with the first character rather than the first non-white character
-- WN: sets the indentation when in unclosed parentheses of the following line N characters relative to the outer context
opt.cindent = true
opt.cinoptions = { "g0", ":0", "1", "-s", "(0", "1", "1s" }

-- Set the visual character to be shown for wrapped lines
-- Disabled, this cause I don't want showbreaks in nvim-cmp documentation
-- opt.showbreak = [[↪\]]

-- This makes searches case insensitive
opt.ignorecase = true

-- This makes searches with a single capital letter to be case sensitive
opt.smartcase = true

-- This highlights the search pattern as you type
opt.incsearch = true

-- This provides live feedback when substituting
opt.inccommand = "split"

-- Open new splits/windows always below and right
opt.splitbelow = true
opt.splitright = true

-- Set automatic wrap to display lines in next line (this is the default)
opt.wrap = true

-- Set the maximum text width before vim automatically wraps it, this inserts the EOL character
-- This is considered a hard-wrap, one can use linebreak to soft-wrap the lines w/o inserting EOL
opt.textwidth = 120

-- Text with conceal syntax will be hidden
opt.conceallevel = 2

-- Concealed text will be hidden in "nc" modes, normal and command
opt.concealcursor = "nc"

-- Set default encoding
opt.encoding = "UTF-8"

-- Set the fileformat to unix because windows line endings are bad
opt.fileformat = "unix"

-- This is used to control the Ctrl + C command and copy to the system's clipboard
opt.clipboard = { "unnamed", "unnamedplus" }

-- This option will render characters for spaces, tabs etc
-- set listchars=trail:·,tab:»·,eol:↲,nbsp:␣,extends:⟩,precedes:⟨
-- set listchars=eol:↴,¬,
opt.list = true
opt.listchars = { nbsp = "␣", extends = "⟩", precedes = "⟨", trail = "·", tab = "»·" }

-- The number of lines to show above/below when navigating
opt.scrolloff = 5

-- This sets the folding method, the default markers are {{{  }}}
opt.foldmethod = "marker"

-- Set fold enabled
opt.foldenable = true

-- Foldopen dictates how folds open, jump means it will open with 'gg', 'G'
opt.foldopen = opt.foldopen + "jump"

-- Enable mouse support
opt.mouse = "a"

-- Enable modeline to allow file secific settings
-- e.g. vim: set sw=2:
opt.modeline = true

-- Make updates happen faster
opt.updatetime = 300

-- Keep windows equal in size after split, close etc
opt.equalalways = true

-- Set transparency for the popup window
opt.pumblend = 15

-- Set pop-up menu height
opt.pumheight = 12

-- Set completeopt to have a better completion experience
opt.completeopt = { "menu", "noinsert", "noselect" }

-- Avoid showing message extra message when using completion
opt.shortmess = opt.shortmess + "c"

-- Set persistent undo
opt.undofile = true

-- Disable swapfiles
opt.swapfile = false

-- Set the title's window to the value of titltestring
opt.title = true

-- Set rg as the grep program
if vim.fn.executable "rg" then
    opt.grepprg = "rg --vimgrep --no-heading --smart-case"
    opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end
