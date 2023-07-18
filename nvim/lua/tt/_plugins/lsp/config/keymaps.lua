local M = {}

local utils = require "tt.utils"

local function hover_on_new_window()
    vim.lsp.buf_request(0, "textDocument/hover", vim.lsp.util.make_position_params(), function(_, result, ctx, config)
        config = config or {}
        config.focus_id = ctx.method

        -- Ignore result since buffer changed. This happens for slow language servers
        if vim.api.nvim_get_current_buf() ~= ctx.bufnr then
            return
        end

        -- No information available
        if not (result and result.contents) then
            return
        end

        local markdown_lines =
            vim.lsp.util.trim_empty_lines(vim.lsp.util.convert_input_to_markdown_lines(result.contents))

        -- No information available
        if vim.tbl_isempty(markdown_lines) then
            return
        end

        -- Open an new window with the hover information
        vim.cmd.new()
        vim.api.nvim_buf_set_option(0, "filetype", "markdown")
        vim.api.nvim_buf_set_option(0, "buftype", "nofile")
        vim.api.nvim_buf_set_option(0, "buflisted", false)
        vim.api.nvim_buf_set_lines(0, 0, -1, false, markdown_lines)
        utils.map("n", "q", "<C-w>c", { buffer = true })
    end)
end

function M.on_attach(_, bufnr)
    local function opts(desc)
        return { desc = desc, buffer = bufnr }
    end

    utils.map("n", "<C-LeftMouse>", "<Cmd>TroubleToggle lsp_references<CR>", opts "Open lsp references in Trouble")
    utils.map("n", "K", vim.lsp.buf.hover, opts "Display hover information about symbol")
    utils.map("n", "<leader>K", hover_on_new_window, opts "Display hover information about symbol on new window")
    utils.map("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts "Go to the definition of the symbol")
    utils.map("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts "Go to the declaration of the symbol")
    utils.map("n", "dl", "<Cmd>lua vim.diagnostic.setloclist()<CR>", opts "Add buffer diagnostics to the loclist")
    utils.map("n", "dq", "<Cmd>lua vim.diagnostic.setqflist()<CR>", opts "Add buffer diagnostics to the qflist")
    utils.map("i", "<M-x>", vim.lsp.buf.signature_help, opts "Display signature information about the symbol")
    utils.map(
        { "n", "v" },
        "<leader>fr",
        "<Cmd>lua vim.lsp.buf.format{ async = true }<CR>",
        opts "Format the current buffer"
    )
    utils.map("n", "<leader>it", function()
        vim.lsp.inlay_hint(bufnr, nil)
    end, opts "Toggle LSP inlay hints")

    local ft = vim.bo.filetype
    if ft == "c" or ft == "cpp" or ft == "h" or ft == "hpp" then
        utils.map("n", "<leader>ko", "<Cmd>ClangdSwitchSourceHeader<CR>", opts "Switch C++ source/header ")
        utils.map("n", "<M-o>", "<Cmd>ClangdSwitchSourceHeader<CR>", opts "Switch C++ source/header ")
    end
end

return M
