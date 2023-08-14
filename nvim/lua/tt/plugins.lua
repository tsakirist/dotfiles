return {
    -- Colorschemes
    {
        {
            "EdenEast/nightfox.nvim",
            config = function()
                require("tt._plugins.nightfox").setup()
            end,
        },
        { "Mofiqul/vscode.nvim", lazy = true },
    },

    -- Improve the default vim.ui interfaces
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        config = function()
            require("tt._plugins.dressing").setup()
        end,
    },

    -- Fancy notifications to replace vim.notify
    {
        "rcarriga/nvim-notify",
        config = function()
            require("tt._plugins.notify").setup()
        end,
    },

    -- Startify greeter screen with integrated session-handling
    {
        "mhinz/vim-startify",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("tt._plugins.startify").setup()
        end,
    },

    -- Bufferline
    {
        "akinsho/bufferline.nvim",
        enabled = false,
        event = "BufRead",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("tt._plugins.bufferline").setup()
        end,
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "BufRead",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "SmiteshP/nvim-navic",
        },
        config = function()
            require("tt._plugins.lualine").setup()
        end,
    },

    -- Winbar
    {
        "utilyre/barbecue.nvim",
        event = "BufRead",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("tt._plugins.barbecue").setup()
        end,
    },

    -- Completely overhaul the UI
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        opts = {
            cmdline = {
                view = "cmdline", -- Use classic cmdline view
            },
            lsp = {
                signature = {
                    auto_open = {
                        enabled = false,
                    },
                },
                override = {
                    -- Override markdown rendering to use Treesitter
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+[%a]?B written" },
                            { find = "^/%w+" },
                            { find = "^E%w+" },
                            { find = "lines" },
                        },
                    },
                    view = "mini",
                },
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                        },
                    },
                    opts = {
                        skip = true,
                    },
                },
            },
            presets = {
                bottom_search = true, -- Use a classic bottom cmdline for search
                command_palette = false, -- Position the cmdline and popupmenu together
                long_message_to_split = true, -- Long messages will be sent to a split
                lsp_doc_border = true, -- Add border to lsp hover and signature
            },
        },
    },

    -- LSP related plugins
    {
        -- Portable package manager to install LSP & DAP servers, linters and formatters
        {
            "williamboman/mason.nvim",
            build = ":MasonUpdate",
            dependencies = {
                "williamboman/mason-lspconfig.nvim",
                "jayp0521/mason-null-ls.nvim",
            },
            config = function()
                require("tt._plugins.lsp.mason").setup()
            end,
        },
        -- Common configuration for LSP servers
        {
            "neovim/nvim-lspconfig",
            event = "BufReadPre",
            dependencies = {
                "SmiteshP/nvim-navic",
                "hrsh7th/cmp-nvim-lsp",
            },
            config = function()
                require("tt._plugins.lsp.config").setup()
            end,
        },
        -- General purpose LSP that allows non-LSP sources to hook to native LSP
        {
            "jose-elias-alvarez/null-ls.nvim",
            event = "BufReadPre",
            config = function()
                require("tt._plugins.lsp.null-ls").setup()
            end,
        },
        -- Render LSP diagnostics using virtual lines
        {
            url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
            keys = "<leader>lt",
            config = function()
                require("lsp_lines").setup()
                local utils = require "tt.utils"
                utils.map("n", "<leader>ll", function()
                    local virtual_lines_enabled = not vim.diagnostic.config().virtual_lines
                    vim.diagnostic.config {
                        virtual_lines = virtual_lines_enabled,
                        virtual_text = not virtual_lines_enabled,
                    }
                end, { desc = "Toggle LSP lines" })
            end,
        },
        -- Incremental LSP based renaming with command preview
        {
            "smjonas/inc-rename.nvim",
            commit = "1343175",
            pin = true,
            keys = "<leader>rn",
            config = function()
                require("inc_rename").setup {
                    show_message = false,
                }
                local utils = require "tt.utils"
                utils.map("n", "<leader>rn", function()
                    require("inc_rename").rename { default = vim.fn.expand "<cword>" }
                end, { desc = "Incremental LSP rename with preview" })
            end,
        },
        -- Show current code context
        {
            "SmiteshP/nvim-navic",
            event = "BufReadPre",
            config = function()
                require("tt._plugins.lsp.nvim-navic").setup()
            end,
        },
        {
            "SmiteshP/nvim-navbuddy",
            event = "BufReadPre",
            dependencies = "MunifTanjim/nui.nvim",
            config = function()
                require("tt._plugins.lsp.nvim-navbuddy").setup()
            end,
        },
        -- Better LSP utilities
        {
            "glepnir/lspsaga.nvim",
            event = "BufReadPre",
            config = function()
                require("tt._plugins.lsp.lsp-saga").setup()
            end,
        },
    },

    -- Git related plugins
    {
        -- Git integrations for buffers
        {
            "lewis6991/gitsigns.nvim",
            event = { "BufRead", "BufNewFile" },
            dependencies = "nvim-lua/plenary.nvim",
            config = function()
                require("tt._plugins.git.gitsigns").setup()
            end,
        },
        -- Better diff view interface and file history
        {
            "sindrets/diffview.nvim",
            cmd = {
                "DiffviewOpen",
                "DiffviewClose",
                "DiffviewFileHistory",
            },
            init = function()
                vim.cmd.cnoreabbrev "dvo DiffviewOpen"
                vim.cmd.cnoreabbrev "dvc DiffviewClose"
                vim.cmd.cnoreabbrev "dvf DiffviewFileHistory"
            end,
            config = function()
                require("tt._plugins.git.diffview").setup()
            end,
        },
        -- Popup about the commit message under cursor
        {
            "rhysd/git-messenger.vim",
            keys = "<leader>gm",
            config = function()
                require("tt._plugins.git.git-messenger").setup()
            end,
        },
        -- Generate shareable git file permalinks
        {
            "ruifm/gitlinker.nvim",
            keys = {
                "<leader>gy",
                "<leader>go",
                "<leader>gO",
                "<leader>gY",
            },
            dependencies = "nvim-lua/plenary.nvim",
            config = function()
                require("tt._plugins.git.gitlinker").setup()
            end,
        },
        -- More pleasant editing experience on commit messages
        {
            "rhysd/committia.vim",
            config = function()
                vim.g.committia_min_window_width = 140
                vim.g.committia_edit_window_width = 90
            end,
        },
        -- Visualize and fix merge conflicts
        {
            "akinsho/git-conflict.nvim",
            event = "BufRead",
            config = function()
                require("tt._plugins.git.git-conflict").setup()
            end,
        },
    },

    -- Autocomplete menu and snippets
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            {
                "L3MON4D3/LuaSnip",
                dependencies = {
                    "tsakirist/friendly-snippets",
                    config = function()
                        require("luasnip.loaders.from_vscode").lazy_load()
                    end,
                },
                config = function()
                    require("luasnip").setup {
                        history = true,
                        delete_check_events = "TextChanged",
                    }
                end,
            },
        },
        config = function()
            require("tt._plugins.nvim-cmp").setup()
        end,
    },

    -- Treesitter related plugins
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        build = function()
            if not _G.HeadlessMode() then
                vim.cmd.TSUpdate()
            end
        end,
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects" },
            { "nvim-treesitter/nvim-treesitter-refactor" },
            { "RRethy/nvim-treesitter-endwise" },
            { "nvim-treesitter/playground" },
        },
        config = function()
            require("tt._plugins.treesitter").setup()
        end,
    },

    -- Navigation enhancements
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        config = function()
            require("tt._plugins.flash").setup()
        end,
    },

    -- Surf easily through the document and move elemetns
    {
        "ziontee113/syntax-tree-surfer",
        keys = {
            "<leader>gt",
            "<M-j>",
            "<M-k>",
            "<M-J>",
            "<M-K>",
            "vm",
            "vn",
        },
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("tt._plugins.syntax-tree-surfer").setup()
        end,
    },

    -- Auto insert brackets, parentheses and more
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        dependencies = "hrsh7th/nvim-cmp",
        config = function()
            require("tt._plugins.nvim-autopairs").setup()
        end,
    },

    --  Treesitter to autoclose and autorename html tags
    {
        "windwp/nvim-ts-autotag",
        dependencies = "nvim-treesitter/nvim-treesitter",
        ft = {
            "html",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "svelte",
            "vue",
        },
    },

    -- Documentation/annotation generator using Treesitter
    {
        "danymat/neogen",
        keys = "<leader>ng",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("tt._plugins.neogen").setup()
        end,
    },

    -- Telescope fuzzy finding
    {
        "nvim-telescope/telescope.nvim",
        cmd = function()
            if pcall(require, "telescope") then
                local cmds = vim.tbl_keys(require("tt._plugins.telescope.commands").commands)
                table.insert(cmds, 1, "Telescope")
                return cmds
            end
        end,
        keys = {
            "<leader>f",
            "<leader>T",
            "<leader>gv",
        },
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-live-grep-args.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            { "tsakirist/telescope-lazy.nvim" },
        },
        config = function()
            require("tt._plugins.telescope").setup()
        end,
    },

    -- Smart and powerful comment plugin
    {
        "numToStr/Comment.nvim",
        keys = {
            { "gc", mode = { "n", "v" } },
            { "gb", mode = { "n", "v" } },
            { "<leader><leader>", mode = { "n", "v" } },
        },
        dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
            require("tt._plugins.comment").setup()
        end,
    },

    -- Display indentation levels with lines
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPre",
        config = function()
            require("tt._plugins.indent-blankline").setup()
        end,
    },

    -- Visualize and operate on indent scope
    {
        "echasnovski/mini.indentscope",
        event = { "BufReadPre", "BufNewFile" },
        init = function()
            require("tt._plugins.mini-indentscope").init()
        end,
        config = function()
            require("tt._plugins.mini-indentscope").setup()
        end,
    },

    -- Align text interactively
    {
        "echasnovski/mini.align",
        keys = {
            { "ga", mode = { "v" } },
        },
        config = function()
            require("mini.align").setup {
                mappings = {
                    start_with_preview = "ga",
                },
            }
        end,
    },

    -- Delete buffers without losing windows layout
    {
        "echasnovski/mini.bufremove",
        keys = {
            {
                "<leader>bd",
                function()
                    require("mini.bufremove").delete(0, false)
                end,
                desc = "Delete current buffer",
            },
            {
                "<leader>bD",
                function()
                    require("mini.bufremove").delete(0, true)
                end,
                desc = "Force delete current buffer",
            },
        },
    },

    -- File explorer tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        cmd = "Neotree",
        keys = {
            "<leader>nf",
            "<leader>nt",
        },
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("tt._plugins.neo-tree").setup()
        end,
    },

    -- Distraction free mode
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        keys = "<F1>",
        config = function()
            require("tt._plugins.zen-mode").setup()
        end,
    },

    -- Automatically save the active session
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        config = function()
            local utils = require "tt.utils"

            require("persistence").setup {
                dir = utils.join_paths(vim.fn.stdpath "data", "sessions", "persistence/"),
                options = { "buffers", "curdir", "globals", "help", "tabpages", "winsize" },
            }

            utils.map("n", "<leader>ps", function()
                require("persistence").stop()
            end, { desc = "Do not save the current session" })
        end,
    },

    -- Pretty list for showing diagnostics, references, quickfix & loclist
    {
        "folke/trouble.nvim",
        keys = "<leader>t",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("tt._plugins.trouble").setup()
        end,
    },

    -- Floating terminal
    {
        "akinsho/toggleterm.nvim",
        cmd = "ToggleTerm",
        keys = {
            "<leader>ft",
            "<leader>vt",
            "<leader>ht",
            "<leader>bt",
            "<leader>lt",
        },
        config = function()
            require("tt._plugins.toggleterm").setup()
        end,
    },

    -- Peak lines easily with :<number>
    {
        "nacro90/numb.nvim",
        event = "BufRead",
        config = function()
            require("tt._plugins.numb").setup()
        end,
    },

    -- Surround mappings for enclosed text
    {
        "kylechui/nvim-surround",
        event = "BufRead",
        config = function()
            require("tt._plugins.nvim-surround").setup()
        end,
    },

    -- Popup window for cycling buffers
    {
        "ghillb/cybu.nvim",
        keys = {
            "<Tab>",
            "<S-Tab>",
        },
        config = function()
            require("tt._plugins.cybu").setup()
        end,
    },

    -- Search and replace panel
    {
        "nvim-pack/nvim-spectre",
        keys = {
            "<leader>sr",
            "<leader>sw",
            "<leader>sf",
        },
        config = function()
            require("tt._plugins.spectre").setup()
        end,
    },

    -- Create arbitrary keymap layers
    {
        "anuvyklack/keymap-layer.nvim",
        event = "BufReadPre",
    },

    -- Create custom submodes and menus
    {
        "anuvyklack/hydra.nvim",
        keys = {
            "<leader>gg",
            "<leader>w",
        },
        dependencies = "lewis6991/gitsigns.nvim",
        config = function()
            require("tt._plugins.hydra").setup()
        end,
    },

    -- Easily invert the word under cursor
    {
        "nguyenvukhang/nvim-toggler",
        keys = "<leader>iw",
        config = function()
            require("nvim-toggler").setup {
                remove_default_keybinds = true,
            }
            local utils = require "tt.utils"
            utils.map({ "n", "v" }, "<leader>iw", require("nvim-toggler").toggle, {
                desc = "Inverts the word under the cursor",
            })
        end,
    },

    -- Split/join blocks of code
    {
        "Wansmer/treesj",
        dependencies = "nvim-treesitter/nvim-treesitter",
        keys = "<leader>sj",
        config = function()
            require("tt._plugins.treesj").setup()
        end,
    },

    -- Resize windows easily
    {
        "mrjones2014/smart-splits.nvim",
        keys = {
            "<leader>rs",
            "<leader>ss",
            "<M-h>",
            "<M-l>",
            "<C-w>h",
            "<C-w>k",
            "<C-w>j",
            "<C-w>l",
        },
        config = function()
            require("tt._plugins.smart-splits").setup()
        end,
    },

    -- Color highlighter
    {
        "NvChad/nvim-colorizer.lua",
        event = "BufReadPre",
        config = function()
            require("colorizer").setup {
                user_default_options = {
                    names = false,
                    mode = "background",
                },
            }
        end,
    },

    -- Wrapper over UNIX shell commands
    {
        "chrisgrieser/nvim-genghis",
        cmd = {
            "Chmodx",
            "Delete",
            "Duplicate",
            "Move",
            "New",
            "Rename",
            "Trash",
        },
        init = function()
            -- Create a `Delete` alias that uses `Trash` command
            vim.api.nvim_create_user_command("Delete", "Trash", {})
        end,
    },

    -- Allows for writing and reading files with sudo permissions from within neovim
    {
        "lambdalisue/suda.vim",
        cmd = { "SudaWrite", "SudoWrite" },
        init = function()
            -- Create a 'SudoWrite' alias that uses 'SudaWrite' command
            vim.api.nvim_create_user_command("SudoWrite", "SudaWrite", {})
        end,
    },

    -- Automatically detect the indentation used in the file
    {
        "tpope/vim-sleuth",
        event = "BufReadPost",
    },

    -- Markdown extension, mainly for conceallevel
    {
        "preservim/vim-markdown",
        ft = "markdown",
        config = function()
            vim.g.vim_markdown_conceal = 1
            vim.g.vim_markdown_conceal_code_blocks = 1
            vim.g.vim_markdown_no_default_key_mappings = 1
            vim.g.vim_markdown_folding_disabled = 1
        end,
    },

    -- Measure the startup-time of neovim
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        config = function()
            vim.g.startuptime_tries = 10
        end,
    },
}
