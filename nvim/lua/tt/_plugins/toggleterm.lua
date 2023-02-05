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

    M.create_normal_terminals()
    M.add_custom_terminals()
end

-- Adds all direction empty terminals which can be toggled on demand
function M.create_normal_terminals()
    local function create_terminal(direction, count)
        local Terminal = require("toggleterm.terminal").Terminal
        local term = Terminal:new {
            direction = direction,
            count = count,
        }

        local keymap
        if direction == "vertical" then
            keymap = "<leader>vt"
        elseif direction == "horizontal" then
            keymap = "<leader>ht"
        end

        local utils = require "tt.utils"
        utils.map({ "n", "t" }, keymap, function()
            term:toggle()
        end, { desc = string.format("Toggle %s terminal", direction) })
    end

    create_terminal("vertical", 99)
    create_terminal("horizontal", 100)
end

-- Table to hold the custom terminals
M.custom_terminals = {}

-- TODO: Fix the code/logic for the custom-terminals and add also lazygit
function M.add_custom_terminal(opts)
    if vim.fn.executable(opts.cmd) ~= 1 then
        vim.notify("Could not find executable '" .. opts.cmd .. "'. Please make sure it's installed properly.")
        return
    end

    local Terminal = require("toggleterm.terminal").Terminal
    local custom_terminal = Terminal:new {
        cmd = opts.cmd,
        count = opts.count,
        direction = opts.direction,
        float_opts = opts.float_opts,
    }

    M.custom_terminals[opts.count] = custom_terminal

    local utils = require "tt.utils"
    local custom_terminal_func =
        string.format("<Cmd>lua require'tt.plugins.toggleterm'.custom_terminal_toggle(%d)<CR>", opts.count)
    utils.map("n", opts.keymap, custom_terminal_func)
end

function M.custom_terminal_toggle(terminal_id)
    if M.custom_terminals[terminal_id] == nil then
        return
    end
    M.custom_terminals[terminal_id]:toggle()
end

function M.add_custom_terminals()
    ---@format { "command", "keymap", "direction", "float_opts" }
    local executables = {}

    for i, executable in pairs(executables) do
        local opts = {
            cmd = executable[1],
            keymap = executable[2],
            float_opts = executable.float_opts or {},
            count = i + 1,
        }
        M.add_custom_terminal(opts)
    end
end

return M
