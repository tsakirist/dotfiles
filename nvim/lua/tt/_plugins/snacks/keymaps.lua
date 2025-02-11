local M = {}

function M.setup()
    local utils = require "tt.utils"

    utils.map("n", { "<leader>lg", "<leader>lt" }, function()
        Snacks.lazygit()
    end, { desc = "Open Lazygit" })

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

    utils.map("n", "<leader>so", Snacks.scratch.open, { desc = "Open scratch buffer" })

    utils.map("n", "<F1>", Snacks.zen.zen, { desc = "Toggle Zen mode" })

    utils.map("n", "<leader>F", Snacks.picker.pick, { desc = "Snacks pickers" })
    utils.map("n", "<leader>fe", Snacks.picker.explorer, { desc = "Snacks explorer" })
    utils.map("n", "<leader>fm", Snacks.picker.keymaps, { desc = "Search keymaps" })
    utils.map("n", "<leader>fa", Snacks.picker.autocmds, { desc = "Search autocommands" })
    utils.map("n", "<leader>fb", Snacks.picker.buffers, { desc = "Search for open buffers" })
    utils.map("n", "<leader>fg", Snacks.picker.grep, { desc = "Live grep" })
    utils.map("n", "<leader>fc", Snacks.picker.commands, { desc = "Search commands" })
    utils.map("n", "<leader>ff", Snacks.picker.files, { desc = "Search for files" })
    utils.map("n", "<leader>fF", Snacks.picker.git_files, { desc = "Search for git files" })
    utils.map("n", "<leader>fH", Snacks.picker.highlights, { desc = "Search for highlights" })
    utils.map("n", "<leader>fM", Snacks.picker.man, { desc = "Search for man pages" })
    utils.map("n", "<leader>fo", Snacks.picker.recent, { desc = "Search for recent files" })
    utils.map("n", "<leader>fh", Snacks.picker.help, { desc = "Search for help tags" })
    utils.map("n", "<leader>fl", Snacks.picker.lines, { desc = "Search for lines in current buffer" })
    utils.map("n", "<leader>fs", Snacks.picker.lsp_symbols, { desc = "Search for LSP document symbols" })
    utils.map("n", "<leader>f:", Snacks.picker.command_history, { desc = "Search for command history" })

    Snacks.toggle.dim():map("<leader>sd", { desc = "Toggle dim mode" })
end

return M
