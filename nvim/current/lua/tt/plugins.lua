return {
    -- Colorschemes
    {
        {
            "EdenEast/nightfox.nvim",
            config = function()
                require("tt.plugins.nightfox").setup()
            end,
        },
        { "Mofiqul/vscode.nvim", lazy = true },
    },

    -- Improve the default vim.ui interfaces
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        config = function()
            require("tt.plugins.dressing").setup()
        end,
    },

    -- Fancy notifications to replace vim.notify
    {
        "rcarriga/nvim-notify",
        config = function()
            require("tt.plugins.notify").setup()
        end,
    },

    -- Startify greeter screen with integrated session-handling
    {
        "mhinz/vim-startify",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("tt.plugins.startify").setup()
        end,
    },

    -- Bufferline
    {
        "akinsho/bufferline.nvim",
        enabled = false,
        event = "BufRead",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("tt.plugins.bufferline").setup()
        end,
    },

    -- Statusline
    {
        "hoob3rt/lualine.nvim",
        event = "BufRead",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "SmiteshP/nvim-navic",
        },
        config = function()
            require("tt.themes.lualine").setup()
        end,
    },

    -- Color highlighter
    {
        "norcalli/nvim-colorizer.lua",
        event = "BufReadPre",
        config = function()
            require("colorizer").setup()
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
            require("tt.plugins.barbecue").setup()
        end,
    },

    -- LSP related plugins
    {
        -- Portable package manager to install LSP & DAP servers, linters and formatters
        {
            "williamboman/mason.nvim",
            dependencies = {
                "williamboman/mason-lspconfig.nvim",
                "jayp0521/mason-null-ls.nvim",
            },
            config = function()
                require("tt.plugins.lsp.mason").setup()
            end,
        },
        -- Common configuration for LSP servers
        {
            "neovim/nvim-lspconfig",
            config = function()
                require("tt.plugins.lsp.nvim-lspconfig").setup()
            end,
        },
        -- General purpose LSP that allows non-LSP sources to hook to native LSP
        {
            "jose-elias-alvarez/null-ls.nvim",
            config = function()
                require("tt.plugins.lsp.null-ls").setup()
            end,
        },
        -- LSP progress indicator
        {
            "j-hui/fidget.nvim",
            event = "BufReadPre",
            config = function()
                require("fidget").setup {
                    text = {
                        spinner = "dots",
                    },
                }
            end,
        },
        -- Preview of implementation in floating-window
        {
            "rmagatti/goto-preview",
            keys = { "gp", "gi" },
            config = function()
                require("tt.plugins.lsp.goto-preview").setup()
            end,
        },
        -- Better code-action experience
        {
            "weilbith/nvim-code-action-menu",
            keys = "<leader>ca",
            config = function()
                vim.g.code_action_menu_show_details = false
                vim.g.code_action_menu_show_diff = true
            end,
        },
        -- Function signature in a floating-window
        {
            "ray-x/lsp_signature.nvim",
            keys = "<leader>x",
            config = function()
                require("tt.plugins.lsp.lsp-signature").setup()
            end,
        },
        -- Render LSP diagnostics using virtual lines
        {
            url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
            keys = "<leader>lt",
            config = function()
                require("lsp_lines").setup()
                local utils = require "tt.utils"
                utils.map("n", "<leader>lt", function()
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
            config = function()
                require("tt.plugins.lsp.nvim-navic").setup()
            end,
        },
        -- Show inlay hints via LSP
        {
            "lvimuser/lsp-inlayhints.nvim",
            config = function()
                require("tt.plugins.lsp.inlay-hints").setup()
            end,
        },
    },

    -- Git related plugins
    {
        -- Git integrations for buffers
        {
            "lewis6991/gitsigns.nvim",
            event = "BufRead",
            dependencies = "nvim-lua/plenary.nvim",
            config = function()
                require("tt.plugins.git.gitsigns").setup()
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
            config = function()
                require("tt.plugins.git.diffview").setup()
            end,
        },
        -- Popup about the commit message under cursor
        {
            "rhysd/git-messenger.vim",
            keys = "<leader>gm",
            config = function()
                require("tt.plugins.git.git-messenger").setup()
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
                require("tt.plugins.git.gitlinker").setup()
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
                require("tt.plugins.git-conflict").setup()
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
                dependencies = "tsakirist/friendly-snippets",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
        },
        config = function()
            require("tt.plugins.nvim-cmp").setup()
        end,
    },

    -- Treesitter related plugins
    {
        "nvim-treesitter/nvim-treesitter",
        event = "BufReadPost",
        build = function()
            -- Perform update only when not in headless mode
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
            require("tt.plugins.treesitter").setup()
        end,
    },

    -- Surf easily through the document and move elemetns
    {
        "ziontee113/syntax-tree-surfer",
        keys = { "<leader>gt", "<M-j>", "<M-k>", "<M-J>", "<M-K>" },
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("tt.plugins.syntax-tree-surfer").setup()
        end,
    },

    -- Auto insert brackets, parentheses and more
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        dependencies = "hrsh7th/nvim-cmp",
        config = function()
            require("tt.plugins.nvim-autopairs").setup()
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
        keys = { "<leader>ng" },
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("tt.plugins.neogen").setup()
        end,
    },

    -- Telescope fuzzy finding
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        keys = "<leader>f",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-live-grep-args.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            { "tsakirist/telescope-lazy.nvim" },
        },
        config = function()
            require("tt.plugins.telescope").setup()
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
            require("tt.plugins.comment").setup()
        end,
    },

    -- Display indentation levels with lines
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPre",
        config = function()
            require("tt.plugins.indent-blankline").setup()
        end,
    },

    -- File explorer tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        keys = { "<leader>ng", "<leader>nt" },
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("tt.plugins.neo-tree").setup()
        end,
    },

    -- Distraction free mode
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        keys = "<F1>",
        config = function()
            require("tt.plugins.zen-mode").setup()
        end,
    },

    -- Pretty list for showing diagnostics, references, quickfix & loclist
    {
        "folke/trouble.nvim",
        keys = "<leader>t",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("tt.plugins.trouble").setup()
        end,
    },

    -- Floating terminal
    {
        "akinsho/toggleterm.nvim",
        keys = "<leader>ft",
        config = function()
            require("tt.plugins.toggleterm").setup()
        end,
    },

    -- Peak lines easily with :<number>
    {
        "nacro90/numb.nvim",
        event = "BufRead",
        config = function()
            require("tt.plugins.numb").setup()
        end,
    },

    -- Surround mappings for enclosed text
    {
        "kylechui/nvim-surround",
        event = "BufRead",
        config = function()
            require("tt.plugins.nvim-surround").setup()
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
            require("tt.plugins.cybu").setup()
        end,
    },

    -- Create custom submodes and menus
    {
        "anuvyklack/hydra.nvim",
        keys = { "<leader>gg", "<leader>w", "<leader>vt" },
        dependencies = "lewis6991/gitsigns.nvim",
        config = function()
            require("tt.plugins.hydra").setup()
        end,
    },

    -- Text alignment done easiliy
    {
        "junegunn/vim-easy-align",
        keys = {
            "<Plug>(EasyAlign)",
            "<Plug>(LiveEasyAlign)",
        },
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
            utils.map(
                { "n", "v" },
                "<leader>iw",
                require("nvim-toggler").toggle,
                { desc = "Inverts the word under the cursor" }
            )
        end,
    },

    -- Split/join blocks of code
    {
        "Wansmer/treesj",
        dependencies = "nvim-treesitter/nvim-treesitter",
        keys = "<leader>sj",
        config = function()
            require("tt.plugins.treesj").setup()
        end,
    },

    -- Vim wrapper for UNIX shell commands
    {
        "tpope/vim-eunuch",
        cmd = {
            "Cfind",
            "Chmod",
            "Clocate",
            "Delete",
            "Lfind",
            "Llocate",
            "Mkdir",
            "Move",
            "Rename",
            "SudoEdit",
            "SudoWrite",
        },
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

    -- Editor config support
    {
        "gpanders/editorconfig.nvim",
        event = "BufRead",
    },

    -- Easiliy resize windows
    {
        "sedm0784/vim-resize-mode",
        keys = { "<C-w>>", "<C-w><" },
    },

    -- Draw ASCII diagrams
    {
        "jbyuki/venn.nvim",
        keys = "<leader>vt",
    },

    -- Measure the startup-time of neovim
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
    },
}
