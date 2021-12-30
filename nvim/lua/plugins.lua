-- Take care of handling the automatic installation of packer
local packer_bootstrap = require("plugins._packer").packer_bootstrap()

return require("packer").startup {
    function(use)
        -- Packer can manage itself
        use { "wbthomason/packer.nvim" }

        -- Improve startup time for Neovim by speeding up loading lua modules
        use {
            "lewis6991/impatient.nvim",
            config = function()
                require "impatient"
                require("impatient").enable_profile()
            end,
        }

        -- Colorschemes
        use { "doums/darcula" }
        use { "ful1e5/onedark.nvim" }
        use {
            "EdenEast/nightfox.nvim",
            config = function()
                require "plugins._nightfox"
            end,
        }

        -- Add file type icons to various plugins
        use { "kyazdani42/nvim-web-devicons" }

        -- Color highlighter
        use {
            "norcalli/nvim-colorizer.lua",
            event = { "BufRead", "BufNewFile" },
            config = function()
                require("colorizer").setup()
            end,
        }

        use {
            "akinsho/bufferline.nvim",
            requires = { "kyazdani42/nvim-web-devicons" },
            config = function()
                require "plugins._bufferline"
            end,
        }

        -- Statusline
        use {
            "hoob3rt/lualine.nvim",
            requires = { "kyazdani42/nvim-web-devicons" },
            config = function()
                require "themes.evil_lualine"
            end,
        }

        -- Distraction free mode
        use {
            "folke/zen-mode.nvim",
            cmd = "ZenMode",
            keys = "<F1>",
            config = function()
                require "plugins._zen-mode"
            end,
        }

        -- Pretty list for showing diagnostics, references, quickfix & loclist
        use {
            "folke/trouble.nvim",
            requires = "kyazdani42/nvim-web-devicons",
            config = function()
                require "plugins._trouble"
            end,
        }

        -- LSP related plugins
        -- TODO: refactor this with a single require for the dependencies for lspconfig
        use {
            "neovim/nvim-lspconfig",
            requires = "williamboman/nvim-lsp-installer",
            config = function()
                require "plugins.lsp._nvim-lspconfig"
            end,
        }
        use {
            "jose-elias-alvarez/null-ls.nvim",
            after = "nvim-lspconfig",
            config = function()
                require "plugins.lsp._null-ls"
            end,
        }
        use {
            "rmagatti/goto-preview",
            after = "nvim-lspconfig",
            config = function()
                require "lua.plugins.lsp._goto-preview"
            end,
        }
        use {
            "weilbith/nvim-code-action-menu",
            keys = { "<leader>ca" },
            cmd = "CodeActionMenu",
            config = function()
                vim.g.code_action_menu_show_details = false
                vim.g.code_action_menu_show_diff = true
            end,
        }
        use {
            "liuchengxu/vista.vim",
            keys = { "<leader>vv", "<leader>vf" },
            cmd = "Vista",
            config = function()
                require "plugins.lsp._vista"
            end,
        }

        -- Treesitter related plugins
        use {
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            requires = {
                {
                    "nvim-treesitter/nvim-treesitter-textobjects",
                    after = "nvim-treesitter",
                },
                {
                    "nvim-treesitter/playground",
                    cmd = "TSPlaygroundToggle",
                    after = "nvim-treesitter",
                },
            },
            config = function()
                require "plugins._treesitter"
            end,
        }

        -- Autocomplete related plugins _and snippets
        use {
            "hrsh7th/nvim-cmp",
            -- event = "InsertEnter",
            requires = {
                {
                    "hrsh7th/cmp-nvim-lsp",
                    after = "nvim-cmp",
                },
                {
                    "hrsh7th/cmp-nvim-lua",
                    after = "nvim-cmp",
                },
                {
                    "hrsh7th/cmp-buffer",
                    after = "nvim-cmp",
                },
                {
                    "hrsh7th/cmp-path",
                    after = "nvim-cmp",
                },
                {
                    "saadparwaiz1/cmp_luasnip",
                    after = "nvim-cmp",
                },
                {
                    "L3MON4D3/LuaSnip",
                    before = "nvim-cmp",
                    requires = "tsakirist/friendly-snippets",
                    config = function()
                        require("luasnip.loaders.from_vscode").lazy_load()
                    end,
                },
            },
            config = function()
                require "plugins._nvim-cmp"
            end,
        }

        -- Auto insert brackets, parentheses and more
        use {
            "windwp/nvim-autopairs",
            after = "nvim-cmp",
            config = function()
                require "plugins._nvim-autopairs"
            end,
        }
        use { "windwp/nvim-ts-autotag", after = "nvim-treesitter" }

        -- Fuzzy finder FZF, this also installs FZF globally
        -- use { "junegunn/fzf", run = "./install --key-bindings --completion --no-update-rc" }
        -- use { "junegunn/fzf.vim", after = "fzf" }

        -- Telescope related plugins
        use {
            "nvim-telescope/telescope.nvim",
            -- cmd = "Telescope",
            -- module = "telescope",
            -- keys = { "<leader>f" },
            requires = {
                { "nvim-lua/plenary.nvim" },
                {
                    "nvim-telescope/telescope-fzf-native.nvim",
                    run = "make",
                    after = "telescope.nvim",
                    config = function()
                        require("telescope").load_extension "fzf"
                    end,
                },
            },
            config = function()
                require "plugins._telescope"
            end,
        }

        -- Smart and powerful comment plugin
        use {
            "numToStr/Comment.nvim",
            event = "BufRead",
            keys = { "gc", "gb" },
            requires = { "JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter" },
            config = function()
                require "plugins._comment"
            end,
        }

        -- Display indentation levels with lines
        use {
            "lukas-reineke/indent-blankline.nvim",
            event = "BufReadPre",
            config = function()
                require "plugins._indent-blankline"
            end,
        }
        -- Nvim-tree
        use {
            "kyazdani42/nvim-tree.lua",
            cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
            keys = { "<leader>nf", "<leader>nt" },
            config = function()
                require "plugins._nvim-tree"
            end,
        }

        -- Floating terminal
        use {
            "akinsho/toggleterm.nvim",
            event = "BufRead",
            config = function()
                require "plugins._toggleterm"
            end,
        }

        -- Git related
        use {
            {
                "lewis6991/gitsigns.nvim",
                event = "BufRead",
                requires = { "nvim-lua/plenary.nvim" },
                config = function()
                    require "plugins._gitsigns"
                end,
            },
            -- More pleasant editing experience on commit messages
            {
                "rhysd/committia.vim",
                ft = "gitcommit",
                config = function()
                    vim.g.committia_min_window_width = 140
                end,
            },
            -- Popup about the commit message under cursor
            {
                "rhysd/git-messenger.vim",
                keys = "<leader>gm",
                config = function()
                    require "plugins._git-messenger"
                end,
            },
        }

        -- Peak lines easily with :<number>
        use {
            "nacro90/numb.nvim",
            event = "BufRead",
            config = function()
                require "plugins._numb"
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
