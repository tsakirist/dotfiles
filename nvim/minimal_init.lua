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

-- Set the signcolumn width
opt.signcolumn = "yes:1"

-- Insert spaces when <Tab> is pressed
opt.expandtab = true

-- Controls the number of space characters inserted when pressing the tab key
opt.tabstop = 4

-- Controls the number of space characters inserted for indentation
opt.shiftwidth = 4

-- Use the indentation level of the previous line when pressing enter
opt.autoindent = true

-- Enable automatic C/C++ program indenting
opt.cindent = true

-- Use the following C/C++ indenting options:
-- gN: sets the indentation of scope declarations like public, private, protected
-- :N: sets the indentation for case labels inside switch statements
-- lN: align with a case label instead of the statement after it in the same line
-- NN: sets the indentation of content inside namespaces
-- (N: sets the indentation when in unclosed parentheses to line up vertically
-- wN: when in unclosed parentheses line up with the first character rather than the first non-white character
-- WN: sets the indentation when in unclosed parentheses of the following line N characters relative to the outer context
opt.cinoptions = { "g0", ":0", "l1", "N-s", "(0", "w1", "W1s" }

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

-- How text with conceal syntax will be shown
opt.conceallevel = 0

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
opt.listchars = {
    space = "·",
    tab = "»·",
    trail = "·",
    nbsp = "␣",
    extends = "⟩",
    precedes = "⟨",
}

-- The number of lines to show above/below when navigating
opt.scrolloff = 5

-- This sets the folding method, the default markers are {{{  }}}
opt.foldmethod = "manual"

-- Foldopen dictates how folds open, jump means it will open with 'gg', 'G'
opt.foldopen = opt.foldopen + "jump"

-- Characters to fill in the various places in the window
opt.fillchars = {
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = " ",
}

-- Enable mouse support
opt.mouse = "a"

-- Disable right click pop-up menu
opt.mousemodel = "extend"

-- Enable modeline to allow file specific settings
-- e.g. vim: set sw=2:
opt.modeline = true

-- Make updates happen faster
opt.updatetime = 300

-- Keep windows equal in size after split, close etc
opt.equalalways = true

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

-- Enable a second stage diff for generated hunks
opt.diffopt = opt.diffopt + "linematch:60"

-- Raise a dialog for certain operations that would normally fail (e.g. unsaved buffer)
opt.confirm = true

-- Automatically change the cwd to the one of the opened buffer
opt.autochdir = false
-- Set up the default shell in neovim
opt.shell = vim.fn.exepath "zsh"

-- Set rg as the grep program
if vim.fn.executable "rg" then
    opt.grepprg = "rg --vimgrep --no-heading --smart-case"
    opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

local helpers = {}

--- Function to zoom-in and zoom-out of the given window in a new tab,
--- whilst also preserving the cursor position.
function helpers.zoom_toggle_new_tab()
    local zoomed_window_id = "zoomed_window"

    -- Do not open new tab for unnamed buffer
    local buf_name = vim.api.nvim_buf_get_name(0)

    if buf_name == "" then
        return
    end

    -- Get the windows in the current tab, excluding those with filetypes listed in `excluded_filetypes`
    local function get_tab_windows()
        local excluded_filetypes = { ["smear-cursor"] = true, snacks_notif = true, noice = true }

        local tab_windows = vim.api.nvim_tabpage_list_wins(0)

        return vim.iter(tab_windows)
            :filter(function(window)
                local buf = vim.api.nvim_win_get_buf(window)
                local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
                return not excluded_filetypes[ft]
            end)
            :totable()
    end

    -- Do not open if it's the only window in the current tab
    local tab_windows = get_tab_windows()
    if #tab_windows == 1 then
        -- Close the tab only if it's opened by this function
        if pcall(vim.api.nvim_tabpage_get_var, 0, zoomed_window_id) then
            vim.cmd.tabclose()
        end
    else
        -- Open a new tab with the current file
        vim.cmd.tabnew(buf_name)

        -- Set a tab local variable indicating that we're in a "zoomed" window
        vim.api.nvim_tabpage_set_var(0, zoomed_window_id, true)
    end
end

--- Function to trim trailing whitespace.
function helpers.trim_trailing_white_space()
    local savedView = vim.fn.winsaveview()
    vim.cmd [[keeppatterns %s/\s\+$//e]]
    vim.fn.winrestview(savedView)
end

--- Function to copy the filename according to the supplied modifier
--- to the system's clipboard.
---@param modifier string: The modifier to use for the filename
function helpers.copy_filename_to_clipboard(modifier)
    local filename = vim.fn.expand("%:" .. modifier)

    if filename ~= "" then
        vim.fn.setreg("+", filename)

        vim.notify(
            ("Copied '%s' to system clipboard!"):format(filename),
            vim.log.levels.INFO,
            { title = "Copy filename to clipboard" }
        )
    end
end

--- Preserves cursor position upon invocation of the supplied cmd.
---@param arg string|function: The command|function to execute.
function helpers.preserve_cursor_position(arg)
    local last_cursor_pos = vim.api.nvim_win_get_cursor(0)

    if type(arg) == "function" then
        arg()
    elseif type(arg) == "string" then
        vim.cmd(arg)
    end

    vim.api.nvim_win_set_cursor(0, last_cursor_pos)
end

--- Returns the start and end position of the current visual selection.
---@return { start_pos:number, end_pos:number}
function helpers.get_visual_selection()
    local visual_range = { start_pos = vim.fn.line "v", end_pos = vim.fn.line "." }

    if visual_range.start_pos > visual_range.end_pos then
        local tmp = visual_range.start_pos

        visual_range.start_pos = visual_range.end_pos

        visual_range.end_pos = tmp
    end

    return visual_range
end

local utils = {}

function utils.map(mode, lhs, rhs, opts)
    local options = { silent = true }

    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    if type(lhs) == "string" then
        lhs = { lhs }
    end

    for _, key in ipairs(lhs) do
        vim.keymap.set(mode, key, rhs, options)
    end
end

-- Save files with ctrl+s
-- Use update instead of :write, to only write the file when modified
utils.map("n", "<C-s>", "<Cmd>update<CR>")
utils.map({ "i", "v" }, "<C-s>", "<Esc><Cmd>update<CR>")

-- Keymaps to quit current buffer with ctrl+q
utils.map({ "n", "i", "v" }, "<C-q>", "<Esc>:q<CR>", { desc = "Quit current window" })

-- Keymap to quit all buffers
utils.map("n", "Q", "<Esc><Cmd>qa!<CR>")
utils.map("n", "<Esc>", "<Cmd>noh<CR><Esc>")
utils.map("n", "<Esc>^[", "<Esc>^[")

-- Add comment
utils.map("n", "<leader><leader>", "gcc", { remap = true })
utils.map("v", "<leader><leader>", "gc", { remap = true })

-- List buffers and open them either on the same window or another
utils.map("n", "<leader>bf", ":ls<CR>:b<Space>", { silent = false })
utils.map("n", "<leader>bs", ":ls<CR>:sb<Space>", { silent = false })
utils.map("n", "<leader>bv", ":ls<CR>:vert sb<Space>", { silent = false })

-- Change buffers quickly
utils.map("n", "]b", "<Cmd>bnext<CR>")
utils.map("n", "[b", "<Cmd>bprevious<CR>")
utils.map("n", "<Tab>", "<Cmd>bnext<CR>")
utils.map("n", "<S-Tab>", "<Cmd>bprevious<CR>")

-- Keep Visual mode selection when indenting text
utils.map("x", ">", ">gv")
utils.map("x", "<", "<gv")

-- Quick movements in Insert mode without having to change to Normal mode
utils.map("i", "<C-h>", "<Left>", { desc = "Move left" })
utils.map("i", "<C-l>", "<Right>", { desc = "Move right" })
utils.map("i", "<C-j>", "<Down>", { desc = "Move down" })
utils.map("i", "<C-k>", "<Up>", { desc = "Move up" })
utils.map("i", "<C-0>", "<C-o>^", { desc = "Move to the first non-blank at the beginning" })
utils.map("i", "<C-a>", "<End>", { desc = "Move to the end" })
utils.map("i", "<C-b>", "<C-o>B", { desc = "Move a WORD backwards" })
utils.map("i", "<C-e>", "<C-o>E<C-o>l", { desc = "Move a WORD forward" })

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

-- Duplicate the current line or lines
utils.map("n", "<leader>d", ":t.<CR>")
utils.map("i", "<leader>d", "<Esc>:t.<CR>")
utils.map("v", "<leader>d", function()
    local visual_selection = helpers.get_visual_selection()
    local lines = vim.api.nvim_buf_get_lines(0, visual_selection.start_pos - 1, visual_selection.end_pos, true)
    vim.api.nvim_buf_set_lines(0, visual_selection.end_pos, visual_selection.end_pos, true, lines)
end)

vim.cmd.colorscheme "habamax"
