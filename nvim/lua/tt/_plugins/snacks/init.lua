local M = {}

function M.setup()
    require("snacks").setup {
        bigfile = {
            enabled = true,
        },
        quickfile = {
            enabled = true,
        },
        notifier = {
            enabled = true,
        },
        zen = require("tt._plugins.snacks.zen").zen,
        dashboard = require("tt._plugins.snacks.dashboard").dashboard,
        picker = require("tt._plugins.snacks.picker").picker,
        scratch = require("tt._plugins.snacks.scratch").scratch,
        styles = require("tt._plugins.snacks.styles").styles,
    }

    local modules = { "keymaps", "commands" }
    for _, module in ipairs(modules) do
        require("tt._plugins.snacks." .. module).setup()
    end
end

return M
