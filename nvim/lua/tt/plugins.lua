return {
    -- Colorschemes
    {
        {
            "EdenEast/nightfox.nvim",
            config = function()
                require("tt._plugins.nightfox").setup()
            end,
        },
        {
            "rose-pine/neovim",
            lazy = true,
            name = "rose-pine",
            config = function()
                require("tt._plugins.rose-pine").setup()
            end,
        },
        { "Mofiqul/vscode.nvim", lazy = true },
    },

    -- Snacks a collection of QoL plugins
    {
        "folke/snacks.nvim",
        config = function()
            require("tt._plugins.snacks").setup()
        end,
    },

    -- Improve the default vim.ui interfaces
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        config = function()
            require("tt._plugins.dressing").setup()
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
        },
        config = function()
            require("tt._plugins.noice").setup()
        end,
    },

    -- Cursor animation with a smear effect
    {
        "sphamba/smear-cursor.nvim",
        event = "BufRead",
        config = function()
            require("smear_cursor").setup {
                -- When "none" it matches the text color at the target position
                cursor_color = "none",
            }

            local enabled = true
            vim.api.nvim_create_user_command("SmearToggle", function()
                enabled = not enabled
                require("smear_cursor").enabled = enabled
            end, { desc = "Toggle smear cursor" })
        end,
    },

    -- LSP related plugins
    {
        -- Common configuration for LSP servers
        {
            "neovim/nvim-lspconfig",
            event = { "BufReadPre", "BufNewFile" },
            dependencies = {
                "SmiteshP/nvim-navic",
                {
                    "folke/lazydev.nvim",
                    dependencies = { "Bilal2453/luvit-meta" },
                    opts = {
                        ft = "lua",
                        cmd = "LazyDev",
                        library = {
                            { path = "luvit-meta/library", words = { "vim%.uv" } },
                            { path = "snacks.nvim", words = { "Snacks", "snacks" } },
                        },
                    },
                },
            },
            config = function()
                require("tt._plugins.lsp.config").setup()
            end,
        },
        -- Portable package manager to install LSP & DAP servers, linters and formatters
        {
            "williamboman/mason.nvim",
            event = { "BufRead", "BufNewFile" },
            cmd = "Mason",
            keys = { "<leader>m" },
            build = ":MasonUpdate",
            dependencies = {
                "williamboman/mason-lspconfig.nvim",
                "neovim/nvim-lspconfig",
            },
            config = function()
                require("tt._plugins.lsp.mason").setup()
            end,
        },
        -- Incremental LSP based renaming with command preview
        {
            "smjonas/inc-rename.nvim",
            keys = { "<leader>rn", "<F2>" },
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
        -- Pretty diagnostics
        {
            "rachartier/tiny-inline-diagnostic.nvim",
            event = "BufRead",
            config = function()
                require("tiny-inline-diagnostic").setup {
                    options = {
                        multilines = true,
                    },
                }
            end,
        },
        -- Sidebar with LSP symbols
        {
            "oskarrrrrrr/symbols.nvim",
            keys = {
                { "<leader>ss", "<Cmd>SymbolsToggle<CR>", mode = "n", desc = "Toggle the symbols sidebar" },
            },
            config = function()
                local recipes = require "symbols.recipes"
                require("symbols").setup(recipes.DefaultFilters, {
                    sidebar = {
                        auto_peek = true,
                        open_direction = "right",
                        close_on_goto = true,
                        cursor_follow = false,
                        keymaps = {
                            ["go"] = "goto-symbol",
                            ["P"] = "open-preview",
                        },
                    },
                    providers = {
                        lsp = {
                            kinds = {
                                default = require("tt.icons").kind,
                            },
                        },
                    },
                })
            end,
        },
        -- LSP diagnostics for all files
        {
            "artemave/workspace-diagnostics.nvim",
            opts = {},
            keys = {
                {
                    "<leader>wd",
                    function()
                        -- Populate diagnostics for all files and open Trouble diagnostics view
                        for _, client in ipairs(vim.lsp.get_clients()) do
                            require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
                        end
                        vim.cmd.Trouble "diagnostics_inline_preview"
                    end,
                    mode = "n",
                    desc = "Populate workspace diagnostics and open Trouble",
                },
            },
        },
        -- Display LSP inlay hints at the end of the line
        {
            "chrisgrieser/nvim-lsp-endhints",
            event = "LspAttach",
            init = function()
                require("tt.utils").map("n", "<leader>im", function()
                    require("lsp-endhints").toggle()
                end, { desc = "Toggle between different inlay hint modes" })
            end,
            opts = {
                autoEnableHints = false,
            },
        },
        {
            "yioneko/nvim-vtsls",
            ft = {
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",
            },
            cmd = {
                "VtsExec",
                "VtsRename",
            },
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
        -- VSCode style diff
        {
            "esmuellert/codediff.nvim",
            dependencies = "MunifTanjim/nui.nvim",
            cmd = "CodeDiff",
            keys = {
                { "<leader>cd", "<Cmd>CodeDiff<CR>", mode = "n", desc = "Open CodeDiff" },
            },
            opts = {
                keymaps = {
                    view = {
                        toggle_explorer = "<leader>e",
                    },
                    explorer = {
                        select = "o",
                        toggle_view_mode = "<leader>v",
                        toggle_stage = "s",
                    },
                },
            },
        },
        -- Popup about the commit message under cursor
        {
            "rhysd/git-messenger.vim",
            keys = "<leader>gm",
            config = function()
                require("tt._plugins.git.git-messenger").setup()
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
        "saghen/blink.cmp",
        event = "InsertEnter",
        version = "1.*",
        dependencies = {
            { "xzbdmw/colorful-menu.nvim", opts = {} },
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
            {
                "zbirenbaum/copilot.lua",
                enabled = false,
                cmd = "Copilot",
                opts = {
                    suggestion = { enabled = false },
                    panel = { enabled = false },
                },
                dependencies = {
                    "fang2hou/blink-copilot",
                },
            },
        },
        config = function()
            require("tt._plugins.blink-cmp").setup()
        end,
    },

    -- Treesitter related plugins
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        branch = "main",
        cmd = { "TSInstall", "TSLog", "TSUninstall", "TSUpdate" },
        event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        enabled = function()
            if vim.fn.executable "tree-sitter" == 0 then
                vim.notify(
                    table.concat({
                        "Treesitter main branch requires 'tree-sitter' CLI to be installed.",
                        "See: https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md",
                    }, "\n"),
                    "error"
                )
                return false
            end
            return true
        end,
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                branch = "main",
                config = function()
                    require("tt._plugins.treesitter").setup_treesitter_textobjects()
                end,
            },
            { "RRethy/nvim-treesitter-endwise" },
        },
        config = function()
            require("tt._plugins.treesitter").setup_treesitter()
        end,
    },

    --Tiny plugin to enhance Neovim's native comments
    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- Lightweight powerful formatter plugin
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
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
        event = "VeryLazy",
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

    -- Move and swap code around in a syntax tree aware manner
    {
        "aaronik/treewalker.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        keys = {
            { "<M-J>", "<Cmd>Treewalker SwapDown<CR>", mode = "n", desc = "Swap node down" },
            { "<M-K>", "<Cmd>Treewalker SwapUp<CR>", mode = "n", desc = "Swap node up" },
            { "<M-j>", "<Cmd>Treewalker SwapRight<CR>", mode = "n", desc = "Swap node right" },
            { "<M-k>", "<Cmd>Treewalker SwapLeft<CR>", mode = "n", desc = "Swap node left" },
        },
        opts = {},
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
        cmd = "Telescope",
        keys = {
            "<leader>fp",
            "<leader>T",
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

    -- Display indentation levels with lines
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
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
            ---@type HlChunk.UserConf
            require("hlchunk").setup {
                chunk = {
                    enable = true,
                    style = {
                        { fg = "#806d9c" },
                        { fg = "#806d9c" },
                    },
                    delay = 50,
                    duration = 200,
                    textobject = "ii",
                },
            }
        end,
    },

    -- Surround mappings for enclosed text
    {
        "nvim-mini/mini.surround",
        event = "BufRead",
        config = function()
            require("tt._plugins.mini-surround").setup()
        end,
    },

    -- Add extra text objects
    {
        "nvim-mini/mini.ai",
        event = "BufRead",
        dependencies = { "nvim-mini/mini.extra" },
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
        "nvim-mini/mini.align",
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

    -- Move lines easily in any direction
    {
        "nvim-mini/mini.move",
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
        "nvim-mini/mini.pairs",
        event = "InsertEnter",
        opts = {},
    },

    -- File explorer like buffer
    {
        "stevearc/oil.nvim",
        cmd = "Oil",
        keys = { "<leader>e" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("tt._plugins.oil").setup()
        end,
    },

    -- Session management
    {
        "stevearc/resession.nvim",
        lazy = true,
        cmd = {
            "SSave",
            "SDelete",
            "SLoad",
            "SLast",
        },
        config = function()
            require("tt._plugins.resession").setup()
        end,
    },

    -- Pretty list for showing diagnostics, references, quickfix & loclist
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        keys = { "<leader>t", "gr", "gi", "<C-LeftMouse>" },
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("tt._plugins.trouble").setup()
        end,
    },

    -- Automatic change normal string to template string when ${} is typed
    {
        "axelvc/template-string.nvim",
        ft = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "python",
        },
        opts = {},
    },

    -- Fancy LSP symbol picker mimicking Zed editor
    {
        "bassamsdata/namu.nvim",
        cmd = "Namu",
        keys = { "<leader>fs", "<leader>fC" },
        config = function()
            require("tt._plugins.namu").setup()
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
            "<leader>ww",
            "<leader>rs",
        },
        dependencies = { "lewis6991/gitsigns.nvim", "mrjones2014/smart-splits.nvim" },
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

    -- Resize windows easily
    {
        "mrjones2014/smart-splits.nvim",
        keys = {
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
            { "<leader>xc", "<Plug>SnipClose", desc = "SnipClose" },
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
        dependencies = "stevearc/dressing.nvim",
        cmd = "Genghis",
        init = function()
            local cmds = {
                { name = "Chmodx", command = ":Genghis chmodx" },
                { name = "Delete", command = ":Genghis trashFile" },
                { name = "Duplicate", command = ":Genghis duplicateFile" },
                { name = "MoveRename", command = ":Genghis moveAndRenameFile" },
                { name = "MoveTo", command = ":Genghis moveToFolderInCwd" },
            }

            for _, cmd in ipairs(cmds) do
                vim.api.nvim_create_user_command(cmd.name, cmd.command, {})
            end
        end,
        opts = {},
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
        event = "BufReadPre",
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

    -- Minimal Eye-candy keys screencaster
    {
        "nvchad/showkeys",
        cmd = "ShowkeysToggle",
        opts = {
            maxkeys = 5,
            show_count = true,
            position = "top-right",
        },
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
