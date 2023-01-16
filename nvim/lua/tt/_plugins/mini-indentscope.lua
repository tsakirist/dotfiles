local M = {}

function M.setup()
    require("mini.indentscope").setup {
        -- Which character to use for drawing scope indicator
        symbol = "│",

        options = {
            -- Whether to first check input line to be a border of adjacent scope.
            -- Use it if you want to place cursor on function header to get scope of its body.
            try_as_border = true,
        },

        draw = {
            -- Delay (in ms) between event and start of drawing scope indicator
            delay = 50,

            -- Animation rule for scope's first drawing. A function which, given
            -- next and total step numbers, returns wait time (in ms). See
            -- |MiniIndentscope.gen_animation| for builtin options. To disable
            -- animation, use `require('mini.indentscope').gen_animation.none()`.
            animation = function()
                return 10
            end,
        },

        -- Mappings for text-objects and motions
        mappings = {
            object_scope = "ii",
            object_scope_with_border = "ai",
            goto_top = "[i",
            goto_bottom = "]i",
        },
    }

    -- Disable the plugin for the following filetypes
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("_mini_indentscope", { clear = true }),
        pattern = { "help", "startify", "gitcommit", "neo-tree", "Trouble", "lazy", "mason" },
        callback = function()
            vim.b.miniindentscope_disable = true
        end,
        desc = "Disable 'mini-indentscope' in the following filetypes",
    })

    -- Disable the plugin when in terminal
    vim.api.nvim_create_autocmd("TermEnter", {
        group = vim.api.nvim_create_augroup("_mini_indentscope", { clear = false }),
        callback = function()
            vim.b.miniindentscope_disable = true
        end,
        desc = "Disable 'mini-indentscope' in terminal",
    })
end

return M
