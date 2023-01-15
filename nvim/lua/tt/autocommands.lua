--- Format options configuration:
--- 't': is required in format options to wrap text in insert mode
--- 'l': a line that is longer than textwidth may not be wraped if 'l' is in format options
--- 'r': makes <CR> key to autocomment when pressing enter in line that contains a comment
--- 'o': insert comment when pressing 'o' or 'O'
--- 'q': allow formatting comments with gq
--- 'j': remove comment leader when joining lines
vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("_format_options", { clear = true }),
    pattern = "*",
    desc = "Format options configuration",
    command = "setlocal fo+=t fo-=r fo-=l fo-=o fo+=q fo+=j",
})

-- Remove trailing whitespaces on write
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("_trim_whitespace", { clear = true }),
    pattern = "*",
    desc = "Remove trailing whitespace on write",
    callback = function()
        require("tt.helper").trim_trailing_white_space()
    end,
})

-- Enable format on save
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("_format_on_save", { clear = true }),
    pattern = { "*.lua", "*.tsx", "*.ts", "*.sh" },
    desc = "Enable format on save",
    callback = function()
        vim.lsp.buf.format()
    end,
})

-- Enable spellcheck for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("_spell_check", { clear = true }),
    pattern = { "text", "gitcommit", "markdown" },
    desc = "Enable spellcheck for specific filetypes",
    command = "setlocal spell wrap",
})

-- Automatically resize windows when host resizes
vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("_auto_resize", { clear = true }),
    pattern = "*",
    desc = "Automatically resize windows when host resizes",
    command = "tabdo wincmd =",
})

-- Enable highlighting when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("_highlight", { clear = true }),
    pattern = "*",
    desc = "Enable highlighting when yanking text",
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Immediately enter insert mode when in a terminal
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter", "WinEnter" }, {
    group = vim.api.nvim_create_augroup("_terminal", { clear = true }),
    pattern = "*",
    desc = "Immediately enter insert mode when in a terminal",
    callback = function()
        if vim.o.buftype == "terminal" and vim.o.filetype ~= "lazy" then
            vim.cmd.startinsert()
        end
    end,
})

-- Remove line numbers when in a terminal
vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("_terminal", { clear = false }),
    pattern = "*",
    desc = "Remove line numbers when in a terminal",
    command = "setlocal nonumber norelativenumber",
})

-- A set of filetypes where just hitting 'q' should exit the buffer/window
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("_faster_quit", { clear = true }),
    pattern = { "help", "man", "lspinfo", "startuptime", "spectre_panel" },
    desc = "A set of filetypes where just hitting 'q' should exit the buffer/window",
    callback = function(event)
        vim.keymap.set("n", "q", "<Cmd>quit<CR>", { silent = true, buffer = event.buf })
    end,
})

-- Automatic toggling between hybrid and absolute line numbers
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
    group = vim.api.nvim_create_augroup("_number_toggle", { clear = true }),
    pattern = "*",
    desc = "Automatic toggling between hybrid and absolute line numbers",
    callback = function()
        if vim.o.number and vim.api.nvim_get_mode().mode ~= "i" then
            vim.o.relativenumber = true
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
    group = vim.api.nvim_create_augroup("_number_toggle", { clear = false }),
    pattern = "*",
    desc = "Automatic toggling between hybrid and absolute line numbers",
    callback = function()
        if vim.o.number then
            vim.o.relativenumber = false
        end
    end,
})

-- Toggle conceallevel when in insert mode and normal mode
vim.api.nvim_create_autocmd("InsertEnter", {
    group = vim.api.nvim_create_augroup("_conceal_toggle", { clear = true }),
    pattern = { "*.md", "*.markdown" },
    desc = "Automatic toggling of conceallevel when in insert/normal mode",
    command = "setlocal conceallevel=0",
})

vim.api.nvim_create_autocmd("InsertLeave", {
    group = vim.api.nvim_create_augroup("_conceal_toggle", { clear = false }),
    pattern = { "*.md", "*.markdown" },
    desc = "Automatic toggling of conceallevel when in insert/normal mode",
    command = "setlocal conceallevel=2",
})
