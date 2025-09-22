local M = {}

function M.setup_treesitter()
    require("nvim-treesitter").setup()

    -- Ensure that these parsers are installed. This is a no-op if the parsers are already installed.
    require("nvim-treesitter").install {
        "bash",
        "c",
        "cmake",
        "comment",
        "cpp",
        "css",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "scss",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
    }

    -- Setup syntax highlighting
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("tt.Treesitter", { clear = true }),
        pattern = "*",
        callback = function()
            pcall(vim.treesitter.start)
        end,
        desc = "Add Treesitter syntax highlighting",
    })
end

function M.setup_treesitter_textobjects()
    require("nvim-treesitter-textobjects").setup()

    local select_mappings = {
        ["if"] = "@function.inner",
        ["af"] = "@function.outer",
        ["il"] = "@loop.inner",
        ["al"] = "@loop.outer",
        ["ic"] = "@conditional.inner",
        ["ac"] = "@conditional.outer",
        ["iC"] = "@class.inner",
        ["aC"] = "@class.outer",
    }

    local utils = require "tt.utils"

    for key, textobject in pairs(select_mappings) do
        utils.map({ "x", "o" }, key, function()
            require("nvim-treesitter-textobjects.select").select_textobject(textobject, "textobjects")
        end)
    end

    utils.map("n", "<leader>sp", function()
        require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
    end, { desc = "Swap with next parameter" })

    utils.map("n", "<leader>sP", function()
        require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.inner"
    end, { desc = "Swap with previous parameter" })

    utils.map("n", "<leader>sm", function()
        require("nvim-treesitter-textobjects.swap").swap_next "@function.outer"
    end, { desc = "Swap with next function" })

    utils.map("n", "<leader>sM", function()
        require("nvim-treesitter-textobjects.swap").swap_previous "@function.outer"
    end, { desc = "Swap with previous function" })

    utils.map({ "n", "x", "o" }, "]m", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
    end, { desc = "Go to next function" })

    utils.map({ "n", "x", "o" }, "[m", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
    end, { desc = "Go to previous function" })

    utils.map({ "n", "x", "o" }, "]z", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
    end, { desc = "Go to next fold" })

    utils.map({ "n", "x", "o" }, "[z", function()
        require("nvim-treesitter-textobjects.move").goto_prev_start("@fold", "folds")
    end, { desc = "Go to previous fold" })
end

return M
