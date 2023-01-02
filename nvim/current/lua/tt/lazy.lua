local utils = require "tt.utils"

local function bootstrap()
    local lazypath = utils.join_paths(vim.fn.stdpath "data", "lazy", "lazy.nvim")
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system {
            "git",
            "clone",
            "--filter=blob:none",
            "--branch=stable",
            "https://github.com/folke/lazy.nvim.git",
            lazypath,
        }
    end
    vim.opt.runtimepath:prepend(lazypath)
end

bootstrap()

require("lazy").setup(require "tt.plugins", {
    root = utils.join_paths(vim.fn.stdpath "data", "lazy"),
    lockfile = utils.join_paths(vim.fn.stdpath "config", "lazy-lock.json"),
    install = {
        missing = true,
        colorscheme = {
            require("tt.plugins.nightfox").theme,
            "habamax",
        },
    },
    checker = {
        enabled = true,
        notify = true,
    },
    change_detection = {
        enabled = true,
        notify = true,
    },
    diff = {
        cmd = "terminal_git",
    },
    performance = {
        cache = {
            enabled = true,
            path = utils.join_paths(vim.fn.stdpath "cache", "lazy", "cache"),
        },
        rtp = {
            disabled_plugins = {
                "gzip",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

utils.map("n", "<leader>lz", vim.cmd.Lazy, { desc = "Open Lazy (plugins manager)" })
