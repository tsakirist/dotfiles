---Prints the supplied value.
function _G.Print(value)
    print(vim.inspect(value))
    return value
end

---Reloads the supplied module.
function _G.Reload(module)
    if pcall(require, "plenary.reload") then
        require("plenary.reload").reload_module(module)
        return require(module)
    end
end

---Reloads my whole Lua configuration.
---Everything is scoped under namespace "tt" hence, it makes it easy to reload everything.
function _G.ReloadConfig()
    print "Reloading lua config..."
    return _G.Reload "tt"
end

local utils = require "tt.utils"

utils.map("n", "<leader>sc", "<Cmd>lua ReloadConfig()<CR>")
vim.cmd "command! ReloadConfig lua ReloadConfig()"
