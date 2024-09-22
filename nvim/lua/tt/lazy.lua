local utils = require "tt.utils"

local function bootstrap()
    local lazypath = utils.join_paths(vim.fn.stdpath "data", "lazy", "lazy.nvim")

    if not vim.uv.fs_stat(lazypath) then
        local ret = vim.system({
            "git",
            "clone",
            "--filter=blob:none",
            "--branch=stable",
            "https://github.com/folke/lazy.nvim.git",
            lazypath,
        }, { text = true }):wait()

        if ret.code ~= 0 then
            vim.api.nvim_echo({
                { "Failed to clone 'lazy.nvim'\n", "ErrorMsg" },
                { ret.stderr, "WarningMsg" },
            }, true, {})
        end
    end

    vim.opt.runtimepath:prepend(lazypath)
end

bootstrap()

require("lazy").setup("tt.plugins", {
    root = utils.join_paths(vim.fn.stdpath "data", "lazy"),
    lockfile = utils.join_paths(vim.fn.stdpath "config", "lazy-lock.json"),
    install = {
        missing = true,
        colorscheme = {
            require("tt._plugins.nightfox").theme,
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
