require("nvim-treesitter.configs").setup {
    ensure_installed = {
        "bash",
        "c",
        "cpp",
        "cmake",
        "comment",
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "python",
        "typescript",
        "tsx",
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
    highlight = {
        enable = true,
        custom_captures = {},
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
        disable = { "c", "cpp" },
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
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
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
    },
}
