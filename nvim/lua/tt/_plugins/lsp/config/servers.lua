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
    lua_ls = {
        settings = {
            Lua = {
                completion = {
                    callSnippet = "Replace",
                },
                runtime = {
                    version = "LuaJIT",
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
                telemetry = {
                    enable = false,
                },
                workspace = {
                    checkThirdParty = false,
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
    yamlls = {},
}

-- List of sources for null_ls
M.null_ls_sources = {
    formatting = {
        prettierd = {},
        shfmt = {
            extra_args = { "-i", "4", "-bn", "-ci", "-sr" },
        },
        stylua = {},
    },
    diagnostics = {
        selene = {},
    },
}

local function extend_capabilities(capabilities)
    if vim.F.npcall(require, "ufo") then
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }
    end
end

function M.setup()
    local common_opts = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
    }

    extend_capabilities(common_opts.capabilities)

    for _, server in ipairs(vim.tbl_keys(M.lsp_servers)) do
        local server_opts = vim.tbl_deep_extend("force", common_opts, M.lsp_servers[server])
        require("lspconfig")[server].setup(server_opts)
    end
end

return M
