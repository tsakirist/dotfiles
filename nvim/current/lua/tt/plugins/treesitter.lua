local M = {}

--- Adds extra Treesitter parsers configurations.
function M.add_extra_parsers()
    -- These are extra optional parsers used by `neorg` plugin
    local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

    local extra_parser_configs = {
        neorg = {
            norg_meta = {
                install_info = {
                    url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
                    files = { "src/parser.c" },
                    branch = "main",
                },
            },
            norg_table = {
                install_info = {
                    url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
                    files = { "src/parser.c" },
                    branch = "main",
                },
            },
        },
    }

    for _, extra_parser_config in pairs(extra_parser_configs) do
        for parser_name, parser_install_info in pairs(extra_parser_config) do
            parser_configs[parser_name] = parser_install_info
        end
    end
end

function M.setup()
    -- Do not run setup when in headless mode
    if _G.HeadlessMode() then
        return
    end

    -- Add extra treesitter parsers
    M.add_extra_parsers()

    require("nvim-treesitter.configs").setup {
        ensure_installed = {
            "bash",
            "c",
            "cmake",
            "comment",
            "cpp",
            "css",
            "html",
            "javascript",
            "json",
            "lua",
            "norg",
            "norg",
            "norg_meta",
            "norg_table",
            "python",
            "tsx",
            "typescript",
            "vim",
        },
        autopairs = {
            enable = true,
        },
        autotag = {
            enable = true,
        },
        context_commentstring = {
            enable = true,
            enable_autocmd = false,
        },
        endwise = {
            enable = true,
        },
        highlight = {
            enable = true,
            custom_captures = {},
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
            disable = { "c", "cpp", "lua" },
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gis",
                node_incremental = "ni",
                node_decremental = "nd",
                scope_incremental = "si",
            },
        },
        refactor = {
            highlight_definitions = {
                enable = true,
                clear_on_cursor_move = false,
            },
            highlight_current_scope = {
                enable = false,
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["al"] = "@loop.outer",
                    ["il"] = "@loop.inner",
                    ["ac"] = "@conditional.outer",
                    ["ic"] = "@conditional.inner",
                    ["aC"] = "@class.outer",
                    ["iC"] = "@class.inner",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>sp"] = "@parameter.inner",
                    ["<leader>sm"] = "@function.outer",
                },
                swap_previous = {
                    ["<leader>sP"] = "@parameter.inner",
                    ["<leader>sM"] = "@function.outer",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]c"] = "@class.outer",
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]C"] = "@class.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[c"] = "@class.outer",
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[C"] = "@class.outer",
                },
            },
        },
        playground = {
            enable = true,
            updatetime = 25,
            persist_queries = false,
            keybindings = {
                toggle_query_editor = "o",
                toggle_hl_groups = "i",
                toggle_injected_languages = "t",
                toggle_anonymous_nodes = "a",
                toggle_language_display = "I",
                focus_language = "f",
                unfocus_language = "F",
                update = "R",
                goto_node = "<cr>",
                show_help = "?",
            },
        },
    }
end

return M
