---Prints the supplied value.
function _G.Print(value)
    print(vim.inspect(value))
    return value
end

---Flushes the supplied module from cache.
function _G.FlushModule(module)
    if pcall(require, "plenary.reload") then
        return require("plenary.reload").reload_module(module)
    end
end

---Reloads the supplied module.
function _G.Reload(module)
    _G.FlushModule(module)
    return require(module)
end

-- Create a wrapper for nvim-web-devicons
function _G.WebDevIcons(path)
    local extension = vim.fn.fnamemodify(path, ":e")
    local filename = vim.fn.fnamemodify(path, ":t")
    return require("nvim-web-devicons").get_icon(filename, extension, { default = true })
end
