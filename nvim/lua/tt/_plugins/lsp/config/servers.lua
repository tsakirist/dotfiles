local M = {}

-- Custom lsp server settings
M.lsp_servers = {
    bashls = {},
    clangd = {
        capabilities = {
            -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
            offsetEncoding = { "utf-16" },
        },
    },
    cmake = {},
    eslint = {
        -- Disable showDocumentation from eslint code-actions menu.
        settings = {
            codeAction = {
                showDocumentation = false,
            },
        },
    },
    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                check = {
                    command = "clippy",
                },
                checkOnSave = true,
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
}

-- List of sources for null_ls
M.null_ls_sources = {
    "clang-format",
    "luacheck",
    "markdownlint",
    "prettierd",
    "rustfmt",
    "shfmt",
    "stylua",
}

function M.setup()
    local common_opts = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
    }

    for _, server in ipairs(vim.tbl_keys(M.lsp_servers)) do
        local server_opts = vim.tbl_deep_extend("force", common_opts, M.lsp_servers[server])
        require("lspconfig")[server].setup(server_opts)
    end
end

return M
