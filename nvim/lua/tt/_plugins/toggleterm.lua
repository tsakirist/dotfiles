local M = {}

function M.setup()
    require("toggleterm").setup {
        open_mapping = "<leader>ft",
        hide_numbers = true, -- Hide the number column in toggleterm buffers
        autochdir = false, -- Automatically follow nvim cwd
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = "2", -- The degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
        start_in_insert = true,
        insert_mappings = true, -- Whether or not the open mapping applies in insert mode
        persist_size = true,
        persist_mode = true,
        close_on_exit = true, -- Close the terminal window when the process exits
        shell = vim.o.shell, -- Change the default shell
        direction = "float", -- Direction: 'vertical' | 'horizontal' | 'window' | 'float'
        auto_scroll = true, -- Automatically scroll to the bottom on terminal output
        float_opts = {
            border = "rounded",
            width = math.floor(vim.o.columns * 0.8),
            height = math.floor(vim.o.lines * 0.8),
            winblend = 5,
        },
        highlights = {
            Normal = { link = "Normal" },
            NormalFloat = { link = "NormalFloat" },
            FloatBorder = { link = "TelescopeBorder" },
        },
        size = function(term)
            if term.direction == "horizontal" then
                return 25
            elseif term.direction == "vertical" then
                return math.floor(vim.o.columns * 0.4)
            end
        end,
        on_create = function(term)
            local utils = require "tt.utils"
            utils.map("t", "<C-q>", function()
                vim.cmd.quit { bang = true }
            end, { buffer = term.bufnr })
        end,
    }

    local utils = require "tt.utils"
    -- These keymaps take also a <count> argument which allows for stacking terminals, e.g. 1<leader>vt, 2<leader>vt
    utils.map({ "n", "t" }, "<leader>vt", [[<Cmd>execute 50+v:count "ToggleTerm direction=vertical"<CR>]])
    utils.map({ "n", "t" }, "<leader>ht", [[<Cmd>execute 100+v:count "ToggleTerm direction=horizontal"<CR>]])
end

return M
