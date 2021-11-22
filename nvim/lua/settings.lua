local o = vim.opt
local cmd = vim.cmd
local fn = vim.fn

-- Neovim settings

-- Syntax highlighting
cmd "syntax on"

-- No compatible
o.compatible = false

-- Set true colors inside nvim
o.termguicolors = true

-- Don't show the (INSERT, REPLACE, VISUAL) modes on the last line
o.showmode = false

-- Highlight the current line and also highlight the column @120 (ruler)
-- o.colorcolumn = 120
o.cursorline = true

-- Set hidden to on so as to be able to change buffers without saving first
o.hidden = true

-- Set hybrid line numbers
o.number = true
o.relativenumber = true

-- Set the number of columns used for line numbers
o.numberwidth = 1

-- Insert spaces when <Tab> is pressed
o.expandtab = true

-- Controls the number of space characters inserted when pressing the tab key
o.tabstop = 4

-- Controls the number of space characters inserted for identation
o.shiftwidth = 4

-- Use the indentation level of the previous line when pressing enter
o.autoindent = true

-- Enable automatic C/C++ program indenting with the following options:
-- NOTE: These options will only apply when `cindent` is on, happens automatically for C-like files
-- gN: sets the indentation of scope declarations like public, private, protected
-- :N: sets the indentation for case labels inside switch statements
-- lN: align with a case label instead of the statement after it in the same line
-- NN: sets the indentation of content inside namespaces
-- (N: sets the indentation when in unclosed parentheses to line up vertically
-- wN: when in unclosed parentheses line up with the first character rather than the first non-white character
-- WN: sets the indentation when in unclosed parentheses of the following line N characters relative to the outer context
o.cindent = true
o.cinoptions = { "g0", ":0", "1", "-s", "(0", "1", "1s" }

-- Set the visual character to be shown for wrapped lines
o.showbreak = [[↪\]]

-- This makes searches case insensitive
o.ignorecase = true

-- This makes searches with a single capital letter to be case sensitive
o.smartcase = true

-- This highlights the search pattern as you type
o.incsearch = true

-- This provides live feedback when substituting
o.inccommand = "split"

-- Open new splits/windows always below and right
o.splitbelow = true
o.splitright = true

-- Set automatic wrap to display lines in next line (this is the default)
o.wrap = true

-- Set the maximum text width before vim automatically wraps it, this inserts the EOL character
-- This is considered a hard-wrap, one can use linebreak to soft-wrap the lines w/o inserting EOL
o.textwidth = 120

-- Set default encoding
o.encoding = "UTF-8"

-- Set the fileformat to unix because windows line endings are bad
o.fileformat = "unix"

-- This is used to control the Ctrl + C command and copy to the system's clipboard
o.clipboard = { "unnamed", "unnamedplus" }

-- This option will render characters for spaces, tabs etc
-- set listchars=trail:·,tab:»·,eol:↲,nbsp:␣,extends:⟩,precedes:⟨
-- set listchars=eol:↴,¬,
o.list = true
o.listchars = { nbsp = "␣", extends = "⟩", precedes = "⟨", trail = "·", tab = "»·" }

-- The number of lines to show above/below when navigating
o.scrolloff = 5

-- This sets the folding method, the default markers are {{{  }}}
o.foldmethod = "marker"

-- Set fold enabled
o.foldenable = true

-- Foldopen dictates how folds open, jump means it will open with 'gg', 'G'
o.foldopen = o.foldopen + "jump"

-- Enable mouse support
o.mouse = "a"

-- Enable modeline to allow file secific settings
-- e.g. vim: set sw=2:
o.modeline = true

-- Make updates happen faster
o.updatetime = 300

-- Keep windows equal in size after split, close etc
o.equalalways = true

-- Set transparency for the popup window
o.pumblend = 15

-- Set pop-up menu height
o.pumheight = 12

-- Set completeopt to have a better completion experience
o.completeopt = { "menu", "noinsert", "noselect" }

-- Avoid showing message extra message when using completion
o.shortmess = o.shortmess + "c"

-- Set rg as the grep program
if fn.executable "rg" then
    o.grepprg = "rg --vimgrep --no-heading --smart-case"
    o.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end
