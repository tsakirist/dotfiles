local M = {}

local setup_diagnostics = function()
    vim.diagnostic.config {
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        virtual_text = {
            spacing = 4,
        },
        signs = true,
        float = {
            show_header = true,
            source = "if_many",
            border = "rounded",
            focusable = false,
            severity_sort = true,
        },
    }

    -- Set custom signs for diagnostics
    local lsp_signs = { Error = "", Hint = "", Info = "", Warn = "" }
    for type, icon in pairs(lsp_signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
end

local setup_hover = function()
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })
end

local setup_highlighting = function(client)
    if client.resolved_capabilities.document_highlight then
        vim.cmd [[
            augroup _lsp_document_highlight
                autocmd!
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]]
    end
end

local setup_formatting = function(client)
    -- Disable default LSP formatting as this will be handled by 'null-ls' LSP
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
end

local setup_handlers = function()
    setup_diagnostics()
    setup_hover()
end

local setup_keymappings = function(_, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- LSP related mappings
    local opts = { noremap = true, silent = true }
    buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "<leader>rn", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<leader>ca", "<Cmd>CodeActionMenu<CR>", opts)
    buf_set_keymap("n", "[d", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]d", "<Cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "dp", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "dp", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "dn", "<Cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<leader>ll", "<Cmd>lua vim.diagnostic.setloclist()<CR>", opts)
    buf_set_keymap("n", "<leader>lq", "<Cmd>lua vim.diagnostic.setqflist()<CR>", opts)
    buf_set_keymap("n", "<leader>ld", "<Cmd>lua vim.diagnostic.open_float()<CR>", opts)
    buf_set_keymap("n", "<leader>fr", "<Cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    buf_set_keymap("n", "<C-LeftMouse>", "<Cmd>TroubleToggle lsp_references<CR>", opts)

    local ft = vim.bo.filetype
    if ft == "c" or ft == "cpp" or ft == "h" or ft == "hpp" then
        -- Alternate between header/source files
        buf_set_keymap("n", "<leader>ko", "<Cmd>ClangdSwitchSourceHeader<CR>", opts)
    end
end

local on_attach = function(client, bufnr)
    setup_keymappings(client, bufnr)
    setup_formatting(client)
    setup_highlighting(client)
end

-- Make a new object describing the LSP client capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Disable LSP snippets for the time being since I do not want
-- to have duplicate snippet suggestions between LuaSnip and LSP snippets
-- TODO: Check that this works for the Lua-based configuration
capabilities.textDocument.completion.completionItem.snippetSupport = false
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
    },
}

-- Add additional capabilities supported by nvim-cmp
local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status_ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end

-- Function to install and setup LSP servers automatically
local setup_servers = function()
    -- Nvim-lsp-installer configuration
    local lsp_installer = require "nvim-lsp-installer"

    lsp_installer.settings {
        ui = {
            icons = {
                server_installed = "✓",
                server_pending = "➜",
                server_uninstalled = "✗",
            },
        },
    }

    lsp_installer.on_server_ready(function(server)
        local opts = {
            on_attach = on_attach,
            capabilities = capabilities,
        }

        -- Custom LSP server settings
        local server_settings = {
            eslint = {
                -- Disable showDocumentation from eslint code-actions menu.
                -- The actual value seems to not be working, just setting it to any value disables the option.
                settings = {
                    codeAction = {
                        showDocumentation = false,
                    },
                },
            },
            sumneko_lua = {
                Lua = {
                    diagnostics = {
                        globals = {
                            "vim",
                        },
                    },
                },
            },
        }

        -- As an interim solution force clangd to use the same encoding
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
        if server.name == "clangd" then
            opts.capabilities.offsetEncoding = { "utf-16" }
        end

        -- Customize the options that are passed to the server
        opts.settings = server_settings[server.name] or {}

        server:setup(opts)
    end)

    -- Define the required LSP servers
    local required_servers = {
        "bashls",
        "clangd",
        "cmake",
        "eslint",
        "pyright",
        "sumneko_lua",
        "tsserver",
        "vimls",
    }

    -- Install missing servers
    for _, server_name in pairs(required_servers) do
        local ok, server = lsp_installer.get_server(server_name)
        if ok then
            if not server:is_installed() then
                -- LSP server installation with UI
                lsp_installer.install(server_name)
                -- Headless LSP server installation
                -- print("Installing lsp_sever: " .. server_name)
                -- server:install()
            end
        end
    end
end

function M.setup()
    setup_handlers()
    setup_servers()

    local utils = require "tt.utils"
    utils.map("n", "<leader>li", "<Cmd>LspInstallInfo<CR>")
end

return M
