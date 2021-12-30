-- How each level is indented and what to prepend.
-- This could make the display more compact or more spacious. e.g., more compact: ["▸ ", ""]
vim.g.vista_icon_indent = { "╰─▸ ", "├─▸ " }

-- Executive used when opening vista sidebar without specifying it.
-- See all the avaliable executives via `:echo g.vista#executives`.
vim.g.vista_default_executive = "nvim_lsp"

-- Set the executive for some filetypes explicitly. Use the explicit executive
-- instead of the default one for these filetypes when using `:Vista` without
-- specifying the executive.
vim.g.vista_executive_for = { cpp = "nvim_lsp" }

-- To enable fzf's preview window set g.vista_fzf_preview.
vim.g.vista_fzf_preview = { "right:50%" }

-- Enable icons
vim.g["vista#renderer#enable_icon"] = 1

-- How to show detailed information of current cursor symbol in Vista
vim.g.vista_echo_cursor_strategy = "floating_win"