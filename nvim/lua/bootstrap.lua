local M = {}

local fn = vim.fn

--TODO: refactor this since i need to change compile_path too be inside ~/.local/share
function M.packer_bootstrap()
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    local packer_bootstrap

    if fn.empty(fn.glob(install_path)) > 0 then
        print("Packer is not currently installed. Will try to donwload packer to: " .. install_path)
        packer_bootstrap = fn.system {
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/wbthomason/packer.nvim",
            install_path,
        }
        vim.cmd "packadd packer.nvim"
    end

    return packer_bootstrap
end

return M
