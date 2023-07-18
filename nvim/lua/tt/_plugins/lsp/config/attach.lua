local M = {}

local function navic_attach(client, bufnr)
    if client.supports_method "textDocument/documentSymbol" then
        vim.g.navic_silence = true
        require("nvim-navic").attach(client, bufnr)
        require("nvim-navbuddy").attach(client, bufnr)
    end
end

local function inlay_hints_attach(client, bufnr)
    if client.supports_method "textDocument/inlayHint" then
        vim.lsp.inlay_hint(bufnr, true)
    end
end

local function highlight_attach(client, bufnr)
    require("tt._plugins.lsp.config.highlight").on_attach(client, bufnr)
end

local function format_attach(client, bufnr)
    require("tt._plugins.lsp.config.format").on_attach(client, bufnr)
end

local function keymaps_attach(client, bufnr)
    require("tt._plugins.lsp.config.keymaps").on_attach(client, bufnr)
    require("tt._plugins.lsp.lsp-saga").on_attach(client, bufnr)
end

local attachers = {
    navic_attach,
    inlay_hints_attach,
    highlight_attach,
    format_attach,
    keymaps_attach,
}

local function on_attach(client, bufnr)
    for _, attach in ipairs(attachers) do
        attach(client, bufnr)
    end
end

function M.setup()
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("tt.LspOnAttach", { clear = true }),
        callback = function(args)
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, bufnr)
        end,
    })
end

return M
