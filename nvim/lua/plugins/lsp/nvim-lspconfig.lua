local setup_diagnostics = function()
    -- Override settings for diagnostics
    vim.diagnostic.config {
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        virtual_text = {
            spacing = 4,
            prefix = "❰", --[[ prefix = "●"  ]]
        },
        float = {
            show_header = true,
            source = "if_many",
            border = "rounded",
            focusable = false,
            severity_sort = true,
        },
    }

    -- Set custom signs for diagnostics
    local lsp_signs = { Error = "", Hint = "", Information = "", Warning = "" }
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

local setup_handlers = function()
    setup_diagnostics()
    setup_hover()
end

local setup_keymappings = function(_, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- Mappings
    local opts = { noremap = true, silent = true }
    buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "<leader>rn", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<leader>ca", "<Cmd>CodeActionMenu<CR>", opts)
    buf_set_keymap("n", "[d", "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]d", "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "dp", "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "dn", "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<leader>ll", "<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
    buf_set_keymap("n", "<leader>ld", "<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
    buf_set_keymap("n", "<leader>fr", "<Cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

local on_attach = function(client, bufnr)
    setup_keymappings(client, bufnr)
    -- Disable default LSP formatting as this will be handled by 'null-ls' LSP
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
end

-- Make a new object describing the LSP client capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Disable LSP snippets for the time being since I do not want
-- to have duplicate snippet suggestions between LuaSnip and LSP snippets
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
        -- TODO: Fix this with a table rather than if-else
        if server.name == "eslint" then
            -- Disable showDocumentation from eslint code-actions menu.
            -- The actual value seems to not be working, just setting it to any value disables the option.
            opts.settings = {
                codeAction = {
                    showDocumentation = false,
                },
            }
        elseif server.name == "sumneko_lua" then
            opts.settings = {
                Lua = {
                    diagnostics = {
                        globals = {
                            "vim", -- Make the LSP recongize the `vim` as global
                        },
                    },
                },
            }
        end

        server:setup(opts)
        vim.cmd [[ do User LspAttachBuffers ]]
    end)

    -- Define the required LSP servers
    local required_servers = { "bashls", "clangd", "cmake", "eslint", "pyright", "sumneko_lua", "tsserver", "vimls" }

    -- Install missing servers
    for _, server_name in pairs(required_servers) do
        local ok, server = lsp_installer.get_server(server_name)
        if ok then
            if not server:is_installed() then
                print("Installing lsp_sever: " .. server_name)
                server:install()
            end
        end
    end
end

-- Setup everything
setup_handlers()
setup_servers()
