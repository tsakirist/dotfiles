-- Shebang abbreviation for bash in scripts
vim.cmd [[iab #! /usr/bin/env bash]]

-- Add current date
vim.cmd [[iab <silent> idt Date: <C-R>=strftime('%c')<CR>]]
