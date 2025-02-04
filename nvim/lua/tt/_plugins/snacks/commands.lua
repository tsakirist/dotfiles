local M = {}

function M.setup()
    vim.api.nvim_create_user_command("Rename", Snacks.rename.rename_file, { desc = "Rename current file" })
end

return M
