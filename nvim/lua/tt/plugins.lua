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
        config = function()
            require("tt._plugins.noice").setup()
        end,
    },

    -- LSP related plugins
    {
        -- Portable package manager to install LSP & DAP servers, linters and formatters
        {
            "williamboman/mason.nvim",
            build = ":MasonUpdate",
            dependencies = { "williamboman/mason-lspconfig.nvim" },
            config = function()
                require("tt._plugins.lsp.mason").setup()
            end,
        },
        -- Common configuration for LSP servers
        {
            "neovim/nvim-lspconfig",
            event = { "BufReadPre", "BufNewFile" },
            dependencies = {
                "SmiteshP/nvim-navic",
                "hrsh7th/cmp-nvim-lsp",
                {
                    "folke/lazydev.nvim",
                    dependencies = { "Bilal2453/luvit-meta" },
                    opts = {
                        ft = "lua",
                        cmd = "LazyDev",
                        library = {
                            { path = "luvit-meta/library", words = { "vim%.uv" } },
                        },
                    },
                },
            },
            config = function()
                require("tt._plugins.lsp.config").setup()
            end,
        },
        -- Incremental LSP based renaming with command preview
        {
            "smjonas/inc-rename.nvim",
            config = function()
                require("inc_rename").setup {
                    show_message = false,
                }

                local utils = require "tt.utils"
                utils.map("n", { "<leader>rn", "<F2>" }, function()
                    return ":IncRename " .. vim.fn.expand "<cword>"
                end, { expr = true, desc = "Incremental LSP rename with preview" })
            end,
        },
        -- File operations using LSP
        {
            "antosha417/nvim-lsp-file-operations",
            event = "LspAttach",
            requires = {
                "nvim-lua/plenary.nvim",
                "nvim-neo-tree/neo-tree.nvim",
            },
            config = true,
        },
        -- Show current code context
        {
            "SmiteshP/nvim-navic",
            event = "BufReadPre",
            config = function()
                require("tt._plugins.lsp.nvim-navic").setup()
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
        cmd = "TSUpdate",
        build = function()
            if not _G.HeadlessMode() then
                vim.cmd.TSUpdate()
            end
        end,
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects" },
            { "nvim-treesitter/nvim-treesitter-refactor" },
            { "RRethy/nvim-treesitter-endwise" },
        },
        config = function()
            require("tt._plugins.treesitter").setup()
        end,
    },

    -- Lightweight powerful formatter plugin
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        dependencies = { "mason.nvim" },
        init = function()
            require("tt._plugins.format.conform").init()
        end,
        config = function()
            require("tt._plugins.format.conform").setup()
        end,
    },

    -- Fold enhancements
    {
        "kevinhwang91/nvim-ufo",
        event = "VimEnter",
        dependencies = {
            { "kevinhwang91/promise-async" },
            {
                "luukvbaal/statuscol.nvim",
                config = function()
                    require("tt._plugins.statuscol").setup()
                end,
            },
        },
        init = function()
            require("tt._plugins.nvim-ufo").init()
        end,
        config = function()
            require("tt._plugins.nvim-ufo").setup()
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

    -- Surf easily through the document and move elements
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

    -- Tag important files
    {
        "cbochs/grapple.nvim",
        event = {
            "BufReadPost",
            "BufNewFile",
        },
        config = function()
            require("tt._plugins.grapple").setup()
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
            "<leader>gb",
            "<leader>gv",
        },
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = vim.fn.executable "make" == 1 and "make" or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && \
                    cmake --build build --config Release  &&  cmake --install build --prefix build",
            },
            { "fdschmidt93/telescope-egrepify.nvim" },
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
        dependencies = { "folke/ts-comments.nvim" },
        config = function()
            require("tt._plugins.comment").setup()
        end,
    },

    -- Display indentation levels with lines
    {
        "lukas-reineke/indent-blankline.nvim",
        version = "2.*",
        event = "BufReadPre",
        config = function()
            require("tt._plugins.indent-blankline").setup()
        end,
    },

    -- Highlight current context
    {
        "shellRaining/hlchunk.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local colors = require("tt._plugins.nightfox").colors()
            ---@type HlChunk.UserConf
            require("hlchunk").setup {
                chunk = {
                    enable = true,
                    style = {
                        { fg = colors.blue.base },
                    },
                    delay = 50,
                    duration = 200,
                    textobject = "ii",
                },
            }
        end,
    },

    -- Visualize and operate on indent scope
    {
        "echasnovski/mini.indentscope",
        event = { "BufReadPre", "BufNewFile" },
        enabled = false,
        init = function()
            require("tt._plugins.mini-indentscope").init()
        end,
        config = function()
            require("tt._plugins.mini-indentscope").setup()
        end,
    },

    -- Add extra text objects
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        dependencies = { "echasnovski/mini.extra" },
        opts = function()
            local ai = require "mini.ai"
            local ai_extra = require "mini.extra"
            return {
                silent = true,
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter {
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    },
                    f = ai.gen_spec.treesitter { a = "@function.outer", i = "@function.inner" },
                    c = ai.gen_spec.treesitter { a = "@class.outer", i = "@class.inner" },
                    g = ai_extra.gen_ai_spec.buffer(),
                    N = ai_extra.gen_ai_spec.number(),
                },
            }
        end,
    },

    -- Align text interactively
    {
        "echasnovski/mini.align",
        event = "BufRead",
        keys = {
            { "ga", mode = { "v" } },
        },
        opts = {
            mappings = {
                start_with_preview = "ga",
            },
        },
    },

    -- Delete buffers without losing windows layout
    {
        "echasnovski/mini.bufremove",
        event = "BufRead",
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

    -- Move lines easily in any direction
    {
        "echasnovski/mini.move",
        event = "BufRead",
        opts = {
            mappings = {
                -- Visual mode
                left = "<C-h>",
                right = "<C-l>",
                down = "<C-j>",
                up = "<C-k>",

                -- Normal mode
                line_left = "<C-h>",
                line_right = "<C-l>",
                line_down = "<C-j>",
                line_up = "<C-k>",
            },
        },
    },

    -- Automatically add and manage character pairs
    {
        "echasnovski/mini.pairs",
        event = "InsertEnter",
        opts = {},
    },

    -- File explorer tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        keys = {
            "<leader>nf",
            "<leader>nt",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("tt._plugins.neo-tree").setup()
        end,
    },

    -- File explorer like buffer
    {
        "stevearc/oil.nvim",
        cmd = "Oil",
        keys = { "<leader>fe" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("tt._plugins.oil").setup()
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
                options = { "buffers", "curdir", "globals", "help", "tabpages", "winsize", "folds" },
            }

            utils.map("n", "<leader>ps", function()
                require("persistence").stop()
            end, { desc = "Do not save the current session" })
        end,
    },

    -- Pretty list for showing diagnostics, references, quickfix & loclist
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
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

    -- Search & Replace UI
    {
        "MagicDuck/grug-far.nvim",
        cmd = "GrugFar",
        keys = {
            "<leader>sr",
            "<leader>sw",
            "<leader>sf",
        },
        config = function()
            require("tt._plugins.grug-far").setup()
        end,
    },

    -- Create custom submodes and menus
    {
        "nvimtools/hydra.nvim",
        keys = {
            "<leader>gg",
            "<leader>w",
        },
        dependencies = "lewis6991/gitsigns.nvim",
        config = function()
            require("tt._plugins.hydra").setup()
        end,
    },

    -- Enhanced increment/decrement operations
    {
        "monaqa/dial.nvim",
        keys = {
            { "<C-a>", mode = { "n", "v" } },
            { "<C-x>", mode = { "n", "v" } },
            { "c<C-a>", mode = "n" },
            { "c<C-x>", mode = "n" },
        },
        config = function()
            require("tt._plugins.dial").setup()
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

    -- Create arbitrary keymap layers
    {
        "anuvyklack/keymap-layer.nvim",
        event = "BufReadPre",
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
        dependencies = "anuvyklack/keymap-layer.nvim",
        config = function()
            require("tt._plugins.smart-splits").setup()
        end,
    },

    -- Run lines/block of code within Neovim
    {
        "michaelb/sniprun",
        branch = "master",
        build = "sh install.sh",
        cmd = {
            "SnipRun",
            "SnipClose",
        },
        keys = {
            {
                "<leader>xx",
                function()
                    local helper = require "tt.helper"
                    helper.preserve_cursor_position ":%SnipRun<CR>"
                end,
                mode = "n",
                desc = "Sniprun the whole buffer",
            },
            { "<leader>xx", "<Plug>SnipRun", mode = "v", desc = "Sniprun visually selected lines" },
            { "<leader>xs", "<Plug>SnipClose", desc = "SnipClose" },
            { "<leader>xr", "<Plug>SnipReset", desc = "SnipReset" },
        },
        opts = {
            display = { "TempFloatingWindow" },
            show_no_output = { "TempFloatingWindow" },
            live_mode_toggle = "enable",
        },
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
        "NMAC427/guess-indent.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- Improve Markdown rendering
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = "markdown",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            code = {
                position = "right",
                width = "block",
                right_pad = 1,
                left_pad = 1,
            },
        },
    },

    -- Nice looking animation for the current buffer
    {
        "eandrju/cellular-automaton.nvim",
        cmd = "CellularAutomaton",
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
