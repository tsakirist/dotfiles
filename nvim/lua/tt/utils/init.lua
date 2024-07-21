local M = {}

--- Creates new mapping(s).
---@param mode string|string[]: can be for example 'n', 'i', 'v' or { 'n', 'i', 'v' }
---@param lhs string|string[]: the left hand side
---@param rhs string|function: the right hand side
---@param opts table?: a table containing the mapping's options e.g. silent, remap
function M.map(mode, lhs, rhs, opts)
    local options = { silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    if type(lhs) == "string" then
        lhs = { lhs }
    end
    for _, key in ipairs(lhs) do
        vim.keymap.set(mode, key, rhs, options)
    end
end

--- Returns the appropriate path separator according to the current OS.
M.path_separator = vim.loop.os_uname().sysname:match "Windows" and "\\" or "/"

--- Joins the passed arguments with the appropriate file separator.
---@vararg any: The paths to join.
---@return string: The final joined path.
function M.join_paths(...)
    return table.concat({ ... }, M.path_separator)
end

--- Opens the given url in the default browser.
---@param url string: The url to open.
function M.open_in_browser(url)
    local open_cmd
    if vim.fn.executable "xdg-open" == 1 then
        open_cmd = "xdg-open"
    elseif vim.fn.executable "explorer" == 1 then
        open_cmd = "explorer"
    elseif vim.fn.executable "open" == 1 then
        open_cmd = "open"
    elseif vim.fn.executable "wslview" == 1 then
        open_cmd = "wslview"
    end

    local ret = vim.fn.jobstart({ open_cmd, url }, { detach = true })
    if ret <= 0 then
        vim.notify(
            string.format("[utils]: Failed to open '%s'\nwith command: '%s' (ret: '%d')", url, open_cmd, ret),
            vim.log.levels.ERROR,
            { title = "[tt.utils]" }
        )
    end
end

--- Trims leading and trailing whitespace from the string.
---@param s string: The string to be trimmed.
---@return string: The trimmed string.
function M.trim(s)
    return s:match("^%s*(.*)"):match "(.-)%s*$"
end

--- Returns whether we're currently inside a git repo.
---@return boolean
function M.is_in_git_repo()
    local res = vim.system({ "git", "rev-parse", "--is-inside-work-tree" }, { text = true }):wait()
    return res.stdout:match "true" ~= nil
end

--- Returns the root path of the current git repository.
---@return string|nil
function M.get_git_root()
    if M.is_in_git_repo() then
        local res = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait()
        return (res.stdout:gsub("\n$", ""))
    end
end

---@alias PadDirection "left" |"right" |"both"
---@alias PadOpts { char?: string, length?: integer, direction?: PadDirection, }

---Pads the given input string with a specified character.
---@param input string: The input string to be padded.
---@param opts? PadOpts: An optional table containing padding options. Defaults to {char = " ", length = 1, direction = "right"}.
---@return string
function M.pad(input, opts)
    local defaults = { char = " ", length = 1, direction = "right" }
    opts = opts or defaults

    local direction = opts.direction or defaults.direction
    if not (direction == "left" or direction == "right" or direction == "both") then
        error "Padding type must be one of 'right, left, both'."
    end

    local length = opts.length or defaults.length
    if length < 0 then
        error "Padding length must be positive."
    end

    local char = opts.char or defaults.char
    local padding = string.rep(char, length)

    if direction == "left" then
        return padding .. input
    elseif direction == "right" then
        return input .. padding
    else
        return padding .. input .. padding
    end
end

return M
