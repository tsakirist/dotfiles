local deps_ok, lsp_config, cmp_nvim_lsp, nvim_navic, utils = pcall(function()
    return require "lspconfig", require "cmp_nvim_lsp", require "nvim-navic", require "tt.utils"
end)

if not deps_ok then
    return
end

local M = {}

local function setup_diagnostics()
    vim.diagnostic.config {
        underline = true,
        virtual_lines = false,
        severity_sort = true,
        virtual_text = true,
        update_in_insert = false,
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
        nvim_navic.attach(client, bufnr)
    end
end

local function setup_formatting(client)
    -- Disable default LSP formatting as this will be handled by 'null-ls' LSP
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
end

local function setup_keymappings(_, bufnr)
    local opts = { buffer = bufnr }
    utils.map("n", "<C-LeftMouse>", "<Cmd>TroubleToggle lsp_references<CR>", opts)
    utils.map("n", "<leader>ca", "<Cmd>CodeActionMenu<CR>", opts)
    utils.map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    utils.map("n", "[d", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    utils.map("n", "]d", "<Cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    utils.map("n", "dl", "<Cmd>lua vim.diagnostic.setloclist()<CR>", opts)
    utils.map("n", "dn", "<Cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    utils.map("n", "do", "<Cmd>lua vim.diagnostic.open_float()<CR>", opts)
    utils.map("n", "dp", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    utils.map("n", "dq", "<Cmd>lua vim.diagnostic.setqflist()<CR>", opts)
    utils.map("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    utils.map("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    utils.map("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", opts)
    utils.map({ "n", "v" }, "<leader>fr", "<Cmd>lua vim.lsp.buf.format{ async = true }<CR>", opts)

    local ft = vim.bo.filetype
    if ft == "c" or ft == "cpp" or ft == "h" or ft == "hpp" then
        utils.map("n", "<leader>ko", "<Cmd>ClangdSwitchSourceHeader<CR>", opts)
        utils.map("n", "<M-o>", "<Cmd>ClangdSwitchSourceHeader<CR>", opts)
    end
end

local function on_attach(client, bufnr)
    setup_keymappings(client, bufnr)
    setup_formatting(client)
    setup_highlighting(client, bufnr)
    setup_navigation(client, bufnr)
end

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

    -- Get the default capabilities for the LSP
    local capabilities = cmp_nvim_lsp.default_capabilities()

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
            settings = {
                Lua = {
                    diagnostics = {
                        globals = {
                            "vim",
                            "jit",
                        },
                    },
                    hint = {
                        enable = true,
                        arrayIndex = "Disable", -- "Enable", "Auto", "Disable"
                        await = true,
                        paramName = "All", -- "All", "Literal", "Disable"
                        paramType = true,
                        semicolon = "Disable", -- "All", "SameLine", "Disable"
                        setType = true,
                    },
                },
            },
        },
        tsserver = {
            settings = {
                typescript = {
                    inlayHints = {
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    },
                },
                javascript = {
                    inlayHints = {
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    },
                },
            },
        },
        clangd = {
            capabilities = {
                -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
                offsetEncoding = { "utf-16" },
            },
        },
    }

    for _, server in ipairs(required_servers) do
        local server_configuration = vim.tbl_deep_extend("force", server_opts, server_settings[server] or {})
        lsp_config[server].setup(server_configuration)
    end
end

function M.setup()
    setup_handlers()
    setup_servers()
end

utils.map("n", "<leader>li", "<Cmd>LspInfo<CR>")

return M
