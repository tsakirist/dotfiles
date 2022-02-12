-- Take care of handling the automatic installation of packer
local packer_bootstrap = require("tt.plugins.packer").packer_bootstrap()

return require("packer").startup {
    function(use)
        -- Packer can manage itself
        use { "wbthomason/packer.nvim" }

        -- Improve startup time for Neovim by speeding up loading lua modules
        use {
            "lewis6991/impatient.nvim",
            config = function()
                require "impatient"
            end,
        }

        -- Colorschemes
        use { "doums/darcula" }
        use { "ful1e5/onedark.nvim" }
        use {
            "EdenEast/nightfox.nvim",
            config = function()
                require("tt.plugins.nightfox").setup()
            end,
        }

        -- Improve the default vim.ui interfaces
        use { "stevearc/dressing.nvim" }

        -- Add file type icons to various plugins
        use { "kyazdani42/nvim-web-devicons" }

        -- Startify greeter screen with integrated session-handling
        use {
            "mhinz/vim-startify",
            config = function()
                require("tt.plugins.startify").setup()
            end,
        }

        -- Color highlighter
        use {
            "norcalli/nvim-colorizer.lua",
            config = function()
                require("colorizer").setup()
            end,
        }

        -- Bufferline
        use {
            "akinsho/bufferline.nvim",
            event = "BufRead",
            requires = { "kyazdani42/nvim-web-devicons" },
            config = function()
                require("tt.plugins.bufferline").setup()
            end,
        }

        -- Statusline component that shows the context of the cursor position
        use {
            "SmiteshP/nvim-gps",
            event = "BufRead",
            requires = "nvim-treesitter/nvim-treesitter",
            after = "lualine.nvim",
            config = function()
                require("tt.plugins.nvim-gps").setup()
            end,
        }

        -- Statusline
        use {
            "hoob3rt/lualine.nvim",
            event = "BufRead",
            requires = { "kyazdani42/nvim-web-devicons" },
            config = function()
                require("tt.themes.lualine").setup()
            end,
        }

        -- Distraction free mode
        use {
            "folke/zen-mode.nvim",
            cmd = "ZenMode",
            keys = "<F1>",
            config = function()
                require("tt.plugins.zen-mode").setup()
            end,
        }

        -- Pretty list for showing diagnostics, references, quickfix & loclist
        use {
            "folke/trouble.nvim",
            requires = "kyazdani42/nvim-web-devicons",
            config = function()
                require("tt.plugins.trouble").setup()
            end,
        }

        -- LSP related plugins
        use {
            -- Installer for LSP servers
            {
                "williamboman/nvim-lsp-installer",
                config = function()
                    require("tt.plugins.lsp.nvim-lsp-installer").setup()
                end,
            },
            -- Common configuration for LSP servers
            {
                "neovim/nvim-lspconfig",
                requires = "williamboman/nvim-lsp-installer",
                after = "nvim-lsp-installer",
                config = function()
                    require("tt.plugins.lsp.nvim-lspconfig").setup()
                end,
            },
            -- General purpose LSP that allows non-LSP sources to hook to native LSP
            {
                "jose-elias-alvarez/null-ls.nvim",
                after = "nvim-lspconfig",
                config = function()
                    require("tt.plugins.lsp.null-ls").setup()
                end,
            },
            -- Preview of implementation in floating-window
            {
                "rmagatti/goto-preview",
                after = "nvim-lspconfig",
                config = function()
                    require("tt.plugins.lsp.goto-preview").setup()
                end,
            },
            -- Better code-action experience
            {
                "weilbith/nvim-code-action-menu",
                keys = { "<leader>ca" },
                cmd = "CodeActionMenu",
                after = "nvim-lspconfig",
                config = function()
                    vim.g.code_action_menu_show_details = false
                    vim.g.code_action_menu_show_diff = true
                end,
            },
            -- Function signature in a floating-window
            {
                "ray-x/lsp_signature.nvim",
                after = "nvim-lspconfig",
                config = function()
                    require("tt.plugins.lsp.lsp-signature").setup()
                end,
            },
            -- Tree-like viewer for symbols
            {
                "liuchengxu/vista.vim",
                keys = { "<leader>vv", "<leader>vf" },
                cmd = "Vista",
                after = "nvim-lspconfig",
                config = function()
                    require("tt.plugins.lsp.vista").setup()
                end,
            },
        }

        -- Treesitter related plugins
        use {
            "nvim-treesitter/nvim-treesitter",
            run = function()
                -- Perform update only when not in headless mode
                if #vim.api.nvim_list_uis() ~= 0 then
                    vim.cmd [[ TSUpdate ]]
                end
            end,
            requires = {
                { "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
                { "nvim-treesitter/nvim-treesitter-refactor", after = "nvim-treesitter" },
                {
                    "nvim-treesitter/playground",
                    cmd = "TSPlaygroundToggle",
                    after = "nvim-treesitter",
                },
            },
            config = function()
                require("tt.plugins.treesitter").setup()
            end,
        }

        -- Autocomplete related plugins and snippets
        use {
            "hrsh7th/nvim-cmp",
            event = "InsertEnter",
            after = "LuaSnip",
            requires = {
                { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
                { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
                { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
                { "hrsh7th/cmp-path", after = "nvim-cmp" },
                { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
                {
                    "L3MON4D3/LuaSnip",
                    requires = "tsakirist/friendly-snippets",
                    config = function()
                        require("luasnip.loaders.from_vscode").lazy_load()
                    end,
                },
            },
            config = function()
                require("tt.plugins.nvim-cmp").setup()
            end,
        }

        -- Auto insert brackets, parentheses and more
        use {
            "windwp/nvim-autopairs",
            after = "nvim-cmp",
            config = function()
                require("tt.plugins.nvim-autopairs").setup()
            end,
        }

        -- Use treesitter to autoclose and autorename html tags
        use {
            "windwp/nvim-ts-autotag",
            after = "nvim-treesitter",
            ft = {
                "html",
                "javascript",
                "javascriptreact",
                "typescriptreact",
                "svelte",
                "vue",
            },
        }

        -- Documentation/annotation generator using Treesitter
        use {
            "danymat/neogen",
            event = "BufRead",
            requires = "nvim-treesitter/nvim-treesitter",
            config = function()
                require("neogen").setup {
                    enable = true,
                }
                vim.keymap.set("n", "<leader>ng", "<Cmd>lua require('neogen').generate()<CR>")
            end,
        }

        -- Telescope fuzzy finding
        use {
            "nvim-telescope/telescope.nvim",
            requires = {
                { "nvim-lua/plenary.nvim" },
                { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
                { "nvim-telescope/telescope-packer.nvim" },
            },
            config = function()
                require("tt.plugins.telescope").setup()
            end,
        }

        -- Smart and powerful comment plugin
        use {
            "numToStr/Comment.nvim",
            event = "BufRead",
            keys = { "gc", "gb" },
            requires = { "JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter" },
            config = function()
                require("tt.plugins.comment").setup()
            end,
        }

        -- Display indentation levels with lines
        use {
            "lukas-reineke/indent-blankline.nvim",
            event = "BufReadPre",
            config = function()
                require("tt.plugins.indent-blankline").setup()
            end,
        }

        -- File explorer tree
        use {
            "kyazdani42/nvim-tree.lua",
            event = "BufRead",
            config = function()
                require("tt.plugins.nvim-tree").setup()
            end,
        }

        -- Floating terminal
        use {
            "akinsho/toggleterm.nvim",
            -- This seems to interfere with the print/notify statements
            -- inside the setup function. So will keep it as non-optional for now.
            -- event = "BufRead",
            config = function()
                require("tt.plugins.toggleterm").setup()
            end,
        }

        -- Git related plugins
        use {
            -- Git integrations for buffers
            {
                "lewis6991/gitsigns.nvim",
                event = "BufRead",
                requires = { "nvim-lua/plenary.nvim" },
                config = function()
                    require("tt.plugins.git.gitsigns").setup()
                end,
            },
            -- Better diff view interface and file history
            {
                "sindrets/diffview.nvim",
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
                requires = "nvim-lua/plenary.nvim",
                config = function()
                    require("tt.plugins.git.gitlinker").setup()
                end,
            },
            -- More pleasant editing experience on commit messages
            {
                "rhysd/committia.vim",
                ft = "gitcommit",
                config = function()
                    vim.g.committia_min_window_width = 140
                    vim.g.committia_edit_window_width = 90
                end,
            },
        }

        -- Peak lines easily with :<number>
        use {
            "nacro90/numb.nvim",
            event = "BufRead",
            config = function()
                require("tt.plugins.numb").setup()
            end,
        }

        -- Switch between single-line and multiline forms of code
        use { "AndrewRadev/splitjoin.vim", keys = { "gS", "gJ" } }

        -- Surround mappings for enclosed text
        use { "tpope/vim-surround", event = "BufRead" }

        -- Text alignment done easiliy
        use { "junegunn/vim-easy-align", keys = { "<Plug>(EasyAlign)", "<Plug>(LiveEasyAlign)" } }

        -- Easiliy resize windows
        use { "sedm0784/vim-resize-mode", event = "BufRead" }

        -- Vim wrapper for UNIX shell commands
        use {
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
        }

        -- Measure the startup-time of neovim
        use { "dstein64/vim-startuptime", cmd = "StartupTime" }

        -- Automatically set up configuration after cloning packer
        if packer_bootstrap then
            require("packer").sync()
        end
    end,
    config = {
        display = {
            open_fn = function()
                return require("packer.util").float { border = "rounded" }
            end,
        },
    },
}
