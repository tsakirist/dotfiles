--- Format options configuration:
--- 't': is required in format options to wrap text in insert mode
--- 'l': a line that is longer than textwidth may not be wraped if 'l' is in format options
--- 'r': makes <CR> key to autocomment when pressing enter in line that contains a comment
--- 'o': insert comment when pressing 'o' or 'O'
--- 'q': allow formatting comments with gq
--- 'j': remove comment leader when joining lines
vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("tt.FormatOptions", { clear = true }),
    pattern = "*",
    desc = "Format options configuration",
    command = "setlocal fo+=t fo-=r fo-=l fo-=o fo+=q fo+=j",
})

-- Remove trailing whitespaces on write
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("tt.TrimWhitespace", { clear = true }),
    pattern = "*",
    callback = function()
        require("tt.helper").trim_trailing_white_space()
    end,
    desc = "Remove trailing whitespace on write",
})

-- Enable spellcheck for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("tt.SpellCheck", { clear = true }),
    pattern = { "text", "gitcommit", "markdown" },
    command = "setlocal spell wrap",
    desc = "Enable spellcheck for specific filetypes",
})

-- Automatically resize windows when host resizes
vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("tt.AutoResize", { clear = true }),
    pattern = "*",
    command = "tabdo wincmd =",
    desc = "Automatically resize windows when host resizes",
})

-- Enable highlighting when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("tt.Highlight", { clear = true }),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank()
    end,
    desc = "Enable highlighting when yanking text",
})

-- Immediately enter insert mode when in a terminal
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter", "WinEnter" }, {
    group = vim.api.nvim_create_augroup("tt.Terminal", { clear = true }),
    pattern = "*",
    callback = function()
        if vim.o.buftype == "terminal" and vim.o.filetype ~= "lazy" then
            vim.cmd.startinsert()
        end
    end,
    desc = "Immediately enter insert mode when in a terminal",
})

-- Remove line numbers when in a terminal
vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("tt.Terminal", { clear = false }),
    pattern = "*",
    command = "setlocal nonumber norelativenumber",
    desc = "Remove line numbers when in a terminal",
})

-- A set of filetypes where just hitting 'q' should exit the buffer/window
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("tt.FasterQuit", { clear = true }),
    pattern = { "help", "man", "lspinfo", "startuptime", "spectre_panel" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<Cmd>quit<CR>", { silent = true, buffer = event.buf })
    end,
    desc = "A set of filetypes where just hitting 'q' should exit the buffer/window",
})

-- Automatic toggling between hybrid and absolute line numbers
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
    group = vim.api.nvim_create_augroup("tt.NumberToggle", { clear = true }),
    pattern = "*",
    callback = function()
        if vim.o.number and vim.api.nvim_get_mode().mode ~= "i" then
            vim.o.relativenumber = true
        end
    end,
    desc = "Automatic toggling between hybrid and absolute line numbers",
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
    group = vim.api.nvim_create_augroup("tt.NumberToggle", { clear = false }),
    pattern = "*",
    callback = function()
        if vim.o.number then
            vim.o.relativenumber = false
        end
    end,
    desc = "Automatic toggling between hybrid and absolute line numbers",
})

-- Toggle conceallevel when in insert mode and normal mode
vim.api.nvim_create_autocmd("InsertEnter", {
    group = vim.api.nvim_create_augroup("tt.ConcealToggle", { clear = true }),
    pattern = { "*.md", "*.markdown", "*.json" },
    command = "setlocal conceallevel=0",
    desc = "Automatic toggling of conceallevel when in insert/normal mode",
})

vim.api.nvim_create_autocmd("InsertLeave", {
    group = vim.api.nvim_create_augroup("tt.ConcealToggle", { clear = false }),
    pattern = { "*.md", "*.markdown", "*.json" },
    command = "setlocal conceallevel=2",
    desc = "Automatic toggling of conceallevel when in insert/normal mode",
})
