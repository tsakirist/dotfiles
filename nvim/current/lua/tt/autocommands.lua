local M = {}

--- Create autocommand groups according to the passed definitions
---@param definitions table:
--- The table should have a key which corresponds to the name of the group
--- and each definition should have:
---  1. Event
---  2. Pattern
---  3. Command
function M.create_augroups(definitions)
    for augroup_name, definition in pairs(definitions) do
        vim.cmd("augroup" .. augroup_name)
        vim.cmd "autocmd!"
        for _, def in pairs(definition) do
            local command = table.concat(vim.tbl_flatten { "autocmd", def }, " ")
            vim.cmd(command)
        end
    end
    vim.cmd "augroup END"
end

function M.load_autocommands()
    local definitions = {
        --- Format options configuration:
        --- 't': is required in format options to wrap text in insert mode
        --- 'l': a line that is longer than textwidth may not be wraped if 'l' is in format options
        --- 'r': makes <CR> key to autocomment when pressing enter in line that contains a comment, enables javadoc
        --- 'o': insert comment when pressing 'o' or 'O'
        --- 'q': allow formatting comments with gq
        _format_options = {
            { "BufEnter", "*", "setlocal fo+=t fo+=r fo-=l fo-=o fo+=q" },
        },
        --- Remove trailing whitespaces on write
        _trim_whitespace = {
            { "BufWritePre", "*", "lua require('tt.helper').trimTrailingWhiteSpace()" },
        },
        --- Enable format on save
        _format_on_save = {
            { "BufWritePre", "*.lua,*.tsx,*.ts,*.sh", "lua vim.lsp.buf.format()" },
        },
        --- Enable spelling for these filetypes
        _spell_check = {
            { "FileType", "text,gitcommit,markdown", "setlocal spell wrap" },
        },
        --- Resize windows when host resizes
        _auto_resize = {
            { "VimResized", "*", "tabdo wincmd =" },
        },
        --- Enable highlighting when yanking text
        _highlight = {
            { "TextYankPost", "*", "silent! lua vim.highlight.on_yank()" },
        },
        --- Enter insert mode and remove line numbers when in terminal
        _terminal = {
            { "TermOpen,BufEnter,WinEnter", "*", "if &buftype == 'terminal' | :startinsert | endif" },
            { "TermOpen", "*", "setlocal nonumber norelativenumber" },
        },
        --- Automatic toggling between hybrid and absolute line numbers
        _number_toggle = {
            { "BufEnter,FocusGained,InsertLeave,WinEnter", "*", "if &nu && mode() != 'i' | set rnu | endif" },
            { "BufLeave,FocusLost,InsertEnter,WinLeave", "*", "if &nu | set nornu | endif" },
        },
        --- Regenerate compiled loader file everytime the plugins file changes
        _packer = {
            { "BufWritePost", "plugins.lua", "source <afile> | PackerCompile" },
        },
        --- A set of filetypes where just hitting q should exit the window
        _faster_quit = {
            { "FileType", "help,man,lspinfo", "nnoremap <silent> <buffer> q :quit<CR>" },
        },
        --- Disables conceallevel and concealcursor for the following filetypes
        _disable_conceal = {
            { "FileType", "json", "setlocal conceallevel=0 concealcursor=" },
        },
        --- Automatic enter insert mode for the following filetypes
        _automatic_insert_mode = {
            { "FileType", "gitcommit", "startinsert" },
        },
    }
    M.create_augroups(definitions)
end

M.load_autocommands()

return M
