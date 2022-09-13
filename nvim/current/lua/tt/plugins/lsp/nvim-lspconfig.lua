local M = {}

local function setup_diagnostics()
    vim.diagnostic.config {
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        virtual_text = true,
        virtual_lines = false,
        signs = true,
        float = {
            show_header = true,
            source = "if_many",
            border = "rounded",
            focusable = false,
            severity_sort = true,
        },
    }

    --- Set custom signs for diagnostics
    local icons = require "tt.icons"
    local lsp_signs = {
        Error = icons.diagnostics.Error,
        Hint = icons.diagnostics.Hint,
        Info = icons.diagnostics.Info,
        Warn = icons.diagnostics.Warn,
    }
    for type, icon in pairs(lsp_signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    --- Status of diagnostics
    M.diagnostics_enabled = true

    --- The record of the last displayed notification
    local diagnostics_notification = nil

    --- Function that toggles diagnostics in all buffers
    local function toggle_diagnostics()
        local diagnostics_title = "Diagnostics"
        if M.diagnostics_enabled then
            vim.diagnostic.disable()
            diagnostics_notification = vim.notify("Diagnostics disabled!", vim.log.levels.INFO, {
                title = diagnostics_title,
                replace = diagnostics_notification,
                on_close = function()
                    diagnostics_notification = nil
                end,
            })
        else
            vim.diagnostic.enable()
            diagnostics_notification = vim.notify("Diagnostics enabled!", vim.log.levels.INFO, {
                title = diagnostics_title,
                replace = diagnostics_notification,
                on_close = function()
                    diagnostics_notification = nil
                end,
            })
        end
        M.diagnostics_enabled = not M.diagnostics_enabled
    end

    -- Add a command to toggle the diagnostics
    vim.api.nvim_create_user_command("ToggleDiagnostics", toggle_diagnostics, {
        desc = "Toggles diagnostics on and off, for all buffers",
    })
end

local function setup_hover()
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })
end

local function setup_definition()
    -- Make LSP handler for definitions to jump directly to the first available result
    vim.lsp.handlers["textDocument/definition"] = function(err, result, ctx, _)
        local title = "LSP definition"
        if err then
            vim.notify(err.message, vim.log.levels.ERROR, { title = title })
            return
        end
        if not result then
            vim.notify("Location not found", vim.log.levels.INFO, { title = title })
            return
        end
        local client_encoding = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding
        if vim.tbl_islist(result) and result[1] then
            vim.lsp.util.jump_to_location(result[1], client_encoding)
        else
            vim.lsp.util.jump_to_location(result, client_encoding)
        end
    end
end

local function setup_handlers()
    setup_diagnostics()
    setup_hover()
    setup_definition()
end

local function setup_highlighting(client, bufnr)
    if client.server_capabilities.documentHighlightProvider then
        local lsp_highlight_augroup = vim.api.nvim_create_augroup("_lsp_document_highlight", {
            clear = true,
        })
        vim.api.nvim_create_autocmd("CursorHold", {
            buffer = bufnr,
            command = "lua vim.lsp.buf.document_highlight()",
            group = lsp_highlight_augroup,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = bufnr,
            command = "lua vim.lsp.buf.clear_references()",
            group = lsp_highlight_augroup,
        })
    end
end

local function setup_navigation(client, bufnr)
    if client.supports_method "textDocument/documentSymbols" then
        -- Suprress error messages from navic
        vim.g.navic_silence = true
        require("nvim-navic").attach(client, bufnr)
    end
end

local function setup_formatting(client)
    -- Disable default LSP formatting as this will be handled by 'null-ls' LSP
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
end

local function setup_keymappings(_, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- LSP keymaps
    local opts = { noremap = true, silent = true }
    buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "<leader>ca", "<Cmd>CodeActionMenu<CR>", opts)
    buf_set_keymap("n", "[d", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]d", "<Cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "dp", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "dn", "<Cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<leader>ll", "<Cmd>lua vim.diagnostic.setloclist()<CR>", opts)
    buf_set_keymap("n", "<leader>lq", "<Cmd>lua vim.diagnostic.setqflist()<CR>", opts)
    buf_set_keymap("n", "<leader>ld", "<Cmd>lua vim.diagnostic.open_float()<CR>", opts)
    buf_set_keymap("n", "<leader>fr", "<Cmd>lua vim.lsp.buf.format{ async = true }<CR>", opts)
    buf_set_keymap("v", "<leader>rf", "<Cmd>lua vim.lsp.buf.range_formatting{ async = true }<CR>", opts)
    buf_set_keymap("n", "<C-LeftMouse>", "<Cmd>TroubleToggle lsp_references<CR>", opts)

    local ft = vim.bo.filetype
    if ft == "c" or ft == "cpp" or ft == "h" or ft == "hpp" then
        -- Alternate between header/source files
        buf_set_keymap("n", "<leader>ko", "<Cmd>ClangdSwitchSourceHeader<CR>", opts)
    end
end

local function on_attach(client, bufnr)
    setup_keymappings(client, bufnr)
    setup_formatting(client)
    setup_highlighting(client, bufnr)
    setup_navigation(client, bufnr)
end

--- Make a new object describing the LSP client capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

--- Add additional capabilities supported by nvim-cmp
local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status_ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end

--- Disable LSP snippets since LuaSnip should be responsible for that
capabilities.textDocument.completion.completionItem.snippetSupport = false
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
    },
}

local function setup_servers()
    -- Define the required LSP servers
    local required_servers = {
        "bashls",
        "clangd",
        "cmake",
        "eslint",
        "pyright",
        "sumneko_lua",
        "tsserver",
    }

    -- Common server options
    local server_opts = {
        on_attach = on_attach,
        capabilities = capabilities,
    }

    -- Custom LSP server settings
    local server_settings = {
        eslint = {
            -- Disable showDocumentation from eslint code-actions menu.
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
                        "jit",
                    },
                },
                hint = {
                    enable = true,
                    arrayIndex = "Enable", -- "Enable", "Auto", "Disable"
                    await = true,
                    paramName = "All", -- "All", "Literal", "Disable"
                    paramType = true,
                    semicolon = "All", -- "All", "SameLine", "Disable"
                    setType = true,
                },
            },
        },
    }

    local lsp_config = require "lspconfig"

    for _, server in ipairs(required_servers) do
        -- As an interim solution force clangd to use the same encoding
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
        if server == "clangd" then
            server_opts.capabilities.offsetEncoding = { "utf-16" }
        end
        server_opts.settings = server_settings[server] or {}
        lsp_config[server].setup(server_opts)
    end
end

local function setup_mason_lspconfig()
    require("mason-lspconfig").setup {
        -- Automatic instllation of servers that are configured via lspconfig
        automatic_installation = true,
    }
end

function M.setup()
    setup_mason_lspconfig()
    setup_handlers()
    setup_servers()
end

local utils = require "tt.utils"
utils.map("n", "<leader>li", "<Cmd>LspInfo<CR>")

return M
