local M = {}

local copilot_enabled = pcall(require, "copilot")

function M.setup()
    require("blink.cmp").setup {
        signature = {
            enabled = true,
        },
        appearance = {
            kind_icons = require("tt.icons").kind_trimmed,
        },
        completion = {
            menu = {
                border = "padded",
                draw = {
                    columns = {
                        { "kind_icon", "label", gap = 2 },
                        { "kind", "source_name", gap = 2 },
                    },
                    components = {
                        source_name = {
                            text = function(ctx)
                                return "[" .. ctx.source_name .. "]"
                            end,
                        },
                        label = {
                            text = function(ctx)
                                return require("colorful-menu").blink_components_text(ctx)
                            end,
                            highlight = function(ctx)
                                return require("colorful-menu").blink_components_highlight(ctx)
                            end,
                        },
                    },
                },
            },
            ghost_text = {
                enabled = true,
            },
            list = {
                selection = {
                    preselect = true,
                    auto_insert = false,
                },
            },
            documentation = {
                auto_show = true,
                window = { border = "rounded" },
            },
        },
        sources = {
            default = function()
                local sources = {
                    "buffer",
                    "lazydev",
                    "lsp",
                    "path",
                    "snippets",
                }
                if copilot_enabled then
                    table.insert(sources, 1, "copilot")
                end
                return sources
            end,
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                },
                copilot = {
                    name = "Copilot",
                    module = "blink-copilot",
                    score_offset = 100,
                    async = true,
                    enabled = copilot_enabled,
                    opts = {
                        kind_icon = require("tt.icons").kind_trimmed.Copilot,
                    },
                },
            },
        },
        fuzzy = {
            implementation = "prefer_rust",
        },
        keymap = {
            preset = "enter",
            ["<Tab>"] = { "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },
        },
    }
end

return M
