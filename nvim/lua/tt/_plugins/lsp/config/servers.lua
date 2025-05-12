local M = {}

-- Custom lsp server settings
M.lsp_servers = {
    bashls = {},
    clangd = {
        cmd = {
            "clangd",
            "-j=4",
            "--background-index",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
            "--header-insertion-decorators",
            "--pch-storage=memory",
        },
    },
    cmake = {},
    eslint = {
        settings = {
            codeAction = {
                showDocumentation = false,
            },
        },
        on_attach = function(_, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("tt.Eslint", { clear = true }),
                buffer = bufnr,
                command = "EslintFixAll",
                desc = "Fixes all eslint errors on save",
            })
        end,
    },
    lua_ls = {
        settings = {
            Lua = {
                completion = {
                    callSnippet = "Replace",
                },
                diagnostics = {
                    globals = {
                        "vim",
                        "jit",
                    },
                },
                hint = {
                    enable = true,
                    arrayIndex = "Disable",
                    await = true,
                    paramName = "All",
                    paramType = true,
                    semicolon = "Disable",
                    setType = true,
                },
                runtime = {
                    version = "LuaJIT",
                },
                telemetry = {
                    enable = false,
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                    },
                },
            },
        },
    },
    ts_ls = {
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
    yamlls = {},
}

-- List of servers that should be manually installed via Mason
M.mason_servers = {
    "shellcheck",
}

local function make_client_capabilities()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    capabilities.textDocument = {
        foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        },
        semanticTokens = {
            multilineTokenSupport = true,
        },
        completion = {
            completionItem = {
                snippetSupport = true,
            },
        },
    }
    return capabilities
end

function M.setup()
    local capabilities = make_client_capabilities()

    -- Setup settings for all servers
    vim.lsp.config("*", {
        capabilities = capabilities,
    })

    -- Setup settings per server and enable auto start
    for _, server in ipairs(vim.tbl_keys(M.lsp_servers)) do
        vim.lsp.config(server, M.lsp_servers[server])
        vim.lsp.enable(server)
    end
end

return M
