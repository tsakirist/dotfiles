local M = {}

--- Bootstraps packer.
--- This will download/clone packer.nvim in case it doesn't exist.
---@returns a value indicating succesful installation/bootstrapping.
function M.packer_bootstrap()
    local utils = require "tt.utils"
    local install_path = utils.join_paths(vim.fn.stdpath "data", "site", "pack", "packer", "start", "packer.nvim")
    local packer_bootstrap = nil

    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.notify(
            string.format("Packer is not currently installed. Packer will be cloned to '%s'\n", install_path),
            vim.log.levels.INFO,
            { title = "Packer bootstrap" }
        )
        packer_bootstrap = vim.fn.system {
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/wbthomason/packer.nvim",
            install_path,
        }
        vim.cmd.packadd "packer.nvim"
    end

    return packer_bootstrap
end

--- Creates and saves a snapshot before initiating a packer-sync procedure.
function M.packer_sync()
    local title = "Packer"
    vim.notify("Creating packer snapshot...", vim.log.levels.INFO, { title = title })
    local snapshot_time = os.date "%a-%d-%b-%Y-%TZ"
    vim.cmd.PackerSnapshot(snapshot_time)
    vim.notify("Syncing packer...", vim.log.levels.INFO, { title = title })
    vim.cmd.PackerSync()
end

local utils = require "tt.utils"
utils.map("n", "<leader>pc", "<Cmd>PackerCompile<CR>")
utils.map("n", "<leader>pC", "<Cmd>PackerClean<CR>")
utils.map("n", "<leader>pi", "<Cmd>PackerInstall<CR>")
utils.map("n", "<leader>ps", "<Cmd>PackerStatus<CR>")
utils.map("n", "<leader>pS", M.packer_sync)
utils.map("n", "<leader>pu", "<Cmd>PackerUpdate<CR>")

return M
