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

    utils.map("n", "<leader>e", Snacks.picker.explorer, { desc = "Snacks explorer" })
    utils.map("n", "<leader>fm", Snacks.picker.keymaps, { desc = "Search keymaps" })
    utils.map("n", "<leader>fa", Snacks.picker.autocmds, { desc = "Search autocommands" })
    utils.map("n", "<leader>F", Snacks.picker.pick, { desc = "Snacks pickers" })

    Snacks.toggle.dim():map("<leader>sd", { desc = "Toggle dim mode" })
end

return M
