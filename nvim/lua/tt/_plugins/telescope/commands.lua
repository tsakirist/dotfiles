local custom_pickers = require "tt._plugins.telescope.pickers"

local M = {}

M.commands = {
    TelescopeNvimConfigFind = {
        cmd = function()
            custom_pickers.action_in_nvim_config "find_files"
        end,
    },
    TelescopeNvimConfigGrep = {
        cmd = function()
            custom_pickers.action_in_nvim_config "live_grep"
        end,
    },
}

function M.setup()
    for _, cmd_name in ipairs(vim.tbl_keys(M.commands)) do
        vim.api.nvim_create_user_command(cmd_name, M.commands[cmd_name].cmd, {})
    end
end

return M
