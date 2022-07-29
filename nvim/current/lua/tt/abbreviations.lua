-- Shebang abbreviation for bash in scripts
vim.cmd.iabbrev "#! #!/usr/bin/env bash"

-- Add current date
vim.cmd.iabbrev "<silent> idt Date: <C-R>=strftime('%c')<CR>"
