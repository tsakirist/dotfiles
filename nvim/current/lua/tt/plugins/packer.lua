local M = {}

--- Bootstraps packer.
--- This will download/clone packer.nvim in case it doesn't exist.
---@returns a value indicating succesful installation/bootstrapping.
function M.packer_bootstrap()
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    local packer_bootstrap = nil

    if fn.empty(fn.glob(install_path)) > 0 then
        vim.notify(string.format("Packer is not currently installed. Packer will be cloned to '%s'\n", install_path))
        packer_bootstrap = fn.system {
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/wbthomason/packer.nvim",
            install_path,
        }
        vim.cmd [[packadd packer.nvim]]
    end

    return packer_bootstrap
end

local utils = require "tt.utils"
utils.map("n", "<leader>pc", "<Cmd>PackerCompile<CR>")
utils.map("n", "<leader>pC", "<Cmd>PackerClean<CR>")
utils.map("n", "<leader>pi", "<Cmd>PackerInstall<CR>")
utils.map("n", "<leader>ps", "<Cmd>PackerStatus<CR>")
utils.map("n", "<leader>pS", "<Cmd>PackerSync<CR>")
utils.map("n", "<leader>pu", "<Cmd>PackerUpdate<CR>")

return M
