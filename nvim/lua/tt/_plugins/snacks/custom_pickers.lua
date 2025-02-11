local M = {}

---@param action "files"|"grep"
M.config_action = function(action)
    local config_path = vim.fn.stdpath "config"
    local final_path = type(config_path) == "string" and config_path or config_path[1]
    local action_string = action == "files" and "Find" or "Grep"
    Snacks.picker.pick(action, {
        title = string.format("%s files (%s)", action_string, final_path),
        cwd = final_path,
    })
end

return M
