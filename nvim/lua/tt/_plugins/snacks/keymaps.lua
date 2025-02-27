local M = {}

local utils = require "tt.utils"
local custom_pickers = require "tt._plugins.snacks.custom_pickers"

local function setup_generic_keymaps()
    utils.map("n", "<leader>nh", function()
        Snacks.notifier.show_history()
    end, { desc = "Show notification history" })

    utils.map("n", "<leader>nd", function()
        Snacks.notifier.hide()
    end, { desc = "Hide all notifications" })

    utils.map("n", "<leader>bd", Snacks.bufdelete.delete, { desc = "Delete current buffer" })

    utils.map("n", "<leader>bD", function()
        Snacks.bufdelete.delete { force = true }
    end, { desc = "Force delete current buffer" })

    utils.map("n", "<leader>s,", Snacks.scratch.open, { desc = "Open scratch buffer" })

    utils.map("n", "<F1>", Snacks.zen.zen, { desc = "Toggle Zen mode" })

    utils.map({ "n", "v" }, "<leader>go", Snacks.gitbrowse.open, { desc = "Git browse file" })

    Snacks.toggle.dim():map("<leader>sd", { desc = "Toggle dim mode" })
end

local function setup_terminal_keymaps()
    utils.map("n", { "<leader>lg", "<leader>lt" }, function()
        Snacks.lazygit()
    end, { desc = "Open Lazygit" })

    utils.map({ "n", "t" }, "<leader>ft", function()
        Snacks.terminal.toggle(nil, {
            env = {
                snacks_terminal_float = "1",
            },
            win = {
                border = "rounded",
                position = "float",
                height = 0.85,
                width = 0.85,
            },
        })
    end, { desc = "Toggle float terminal" })

    utils.map({ "n", "t" }, "<leader>ht", function()
        Snacks.terminal.toggle(nil, {
            env = {
                snacks_terminal_horizontal = "1",
            },
            win = {
                position = "bottom",
            },
        })
    end, { desc = "Toggle horizontal terminal" })

    utils.map({ "n", "t" }, "<leader>vt", function()
        Snacks.terminal.toggle(nil, {
            env = {
                snacks_terminal_vertical = "1",
            },
            win = {
                position = "right",
            },
        })
    end, { desc = "Toggle vertical terminal" })

    utils.map({ "n", "t" }, "<leader>bt", function()
        Snacks.terminal.toggle("btop", {
            win = {
                height = 0.85,
                width = 0.85,
            },
        })
    end, { desc = "Toggle btop terminal" })
end

local function setup_picker_keymaps()
    utils.map("n", "<leader>F", Snacks.picker.pick, { desc = "Snacks pickers" })
    utils.map("n", "<leader>fa", Snacks.picker.autocmds, { desc = "Search autocommands" })
    utils.map("n", "<leader>fb", Snacks.picker.buffers, { desc = "Search for open buffers" })
    utils.map("n", "<leader>fc", Snacks.picker.commands, { desc = "Search commands" })
    utils.map("n", "<leader>fe", Snacks.picker.explorer, { desc = "Snacks explorer" })
    utils.map("n", "<leader>ff", Snacks.picker.files, { desc = "Search for files" })
    utils.map("n", "<leader>fg", Snacks.picker.grep, { desc = "Live grep" })
    utils.map("n", "<leader>fh", Snacks.picker.help, { desc = "Search for help tags" })
    utils.map("n", "<leader>fl", Snacks.picker.lines, { desc = "Search for lines in current buffer" })
    utils.map("n", "<leader>fm", Snacks.picker.keymaps, { desc = "Search keymaps" })
    utils.map("n", "<leader>fn", Snacks.picker.notifications, { desc = "Search for notifications" })
    utils.map({ "n", "v" }, "<leader>fw", Snacks.picker.grep_word, { desc = "Search for visual selection or word" })
    utils.map("n", "<leader>fF", Snacks.picker.git_files, { desc = "Search for git files" })
    utils.map("n", "<leader>fH", Snacks.picker.highlights, { desc = "Search for highlights" })
    utils.map("n", "<leader>fM", Snacks.picker.man, { desc = "Search for man pages" })
    utils.map("n", "<leader>fC", Snacks.picker.colorschemes, { desc = "List available colorschemes" })
    utils.map("n", "<leader>f:", Snacks.picker.command_history, { desc = "Search for command history" })
    utils.map("n", "<leader>f/", Snacks.picker.search_history, { desc = "Search for search history" })
    utils.map("n", "<leader>gb", Snacks.picker.grep_buffers, { desc = "Live grep in open buffers" })
    utils.map("n", "<leader>so", Snacks.picker.smart, { desc = "Smart open" })

    utils.map("n", "<leader>fv", function()
        custom_pickers.config_action "files"
    end, { desc = "Find files in config" })

    utils.map("n", "<leader>gv", function()
        custom_pickers.config_action "grep"
    end, { desc = "Grep files in config" })

    utils.map("n", "<leader>fS", custom_pickers.show_sessions, { desc = "Search for saved sessions" })
end

function M.setup()
    local setups = {
        setup_generic_keymaps,
        setup_terminal_keymaps,
        setup_picker_keymaps,
    }

    for _, setup in ipairs(setups) do
        setup()
    end
end

return M
