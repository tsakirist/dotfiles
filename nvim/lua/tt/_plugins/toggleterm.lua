local M = {}

local utils = require "tt.utils"

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
            utils.map("t", "<C-q>", function()
                vim.cmd.quit { bang = true }
            end, { buffer = term.bufnr })

            if not M.is_custom_terminal(term) then
                -- In non-custom terminals htting `ESC` will transition to normal mode
                utils.map("t", "<Esc>", [[<C-\><C-N>]], { buffer = term.bufnr })
            end
        end,
    }

    -- These keymaps take also a <count> argument which allows for stacking terminals, e.g. 1<leader>vt, 2<leader>vt
    utils.map({ "n", "t" }, "<leader>vt", [[<Cmd>execute 50+v:count "ToggleTerm direction=vertical"<CR>]])
    utils.map({ "n", "t" }, "<leader>ht", [[<Cmd>execute 100+v:count "ToggleTerm direction=horizontal"<CR>]])

    -- Enhance functionality with custom terminals
    M.add_custom_terminals()
end

--- Custom terminals configuration options
M.custom_terminals = {
    btop = {
        cmd = "btop",
        keymap = "<leader>bt",
        float_opts = {},
    },
    lazygit = {
        cmd = "lazygit",
        float_opts = {
            width = math.floor(vim.o.columns * 0.9),
            height = math.floor(vim.o.lines * 0.9),
        },
        keymap = "<leader>lt",
    },
}

--- Checks whether the supplied terminal is one of the custom terminals.
---@param term any
---@return boolean
function M.is_custom_terminal(term)
    for _, custom_terminal in pairs(M.custom_terminals) do
        if custom_terminal.cmd == term.cmd then
            return true
        end
    end
    return false
end

--- Adds/creates a terminnal with a custom configuration.
---@param custom_terminal any: Custom terminal configuration option.
function M.add_custom_terminal(custom_terminal)
    if vim.fn.executable(custom_terminal.cmd) == 0 then
        vim.schedule(function()
            vim.notify(
                string.format(
                    "Custom terminal cmd: '%s' is not executable. Please make sure it's installed properly and it is in PATH.",
                    custom_terminal.cmd
                ),
                vim.log.levels.WARN,
                { title = "[tt.toggleterm]" }
            )
        end)
        return
    end

    local Terminal = require("toggleterm.terminal").Terminal
    local terminal = Terminal:new {
        cmd = custom_terminal.cmd,
        float_opts = custom_terminal.float_opts or {},
        hidden = true,
    }

    utils.map({ "n", "t" }, custom_terminal.keymap, function()
        terminal:toggle()
    end)
end

--- Adds/creates all the custom terminals defined in the custom configuration table.
function M.add_custom_terminals()
    for _, custom_terminal in pairs(M.custom_terminals) do
        M.add_custom_terminal(custom_terminal)
    end
end

return M
