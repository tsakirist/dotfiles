local M = {}

local utils = require "tt.utils"

--- Custom picker for actions in my configuration files
---@param action "files"|"grep"
function M.config_action(action)
    local config_path = vim.fn.stdpath "config"
    local final_path = type(config_path) == "string" and config_path or config_path[1]
    local action_string = action == "files" and "Find" or "Grep"
    Snacks.picker.pick(action, {
        title = string.format("%s files (%s)", action_string, final_path),
        cwd = final_path,
    })
end

-- Custom picker to find resession sessions and perform actions
function M.show_sessions()
    local ok, resession = pcall(require, "resession")
    if not ok then
        vim.notify("**resession** is not installed.", vim.log.levels.WARN, { title = "Telescope pickers" })
        return
    end

    local function remove_extension(filename)
        return filename:gsub("%.json$", "")
    end

    Snacks.picker.files {
        title = "Sessions",
        layout = "select",
        cwd = utils.join_paths(vim.fn.stdpath "data", "sessions/resession"),
        transform = function(item)
            return { file = remove_extension(item.file), text = item.file, idx = item.idx }
        end,
        actions = {
            session_delete = function(self, item)
                resession.delete(item.file)
                self:find { refresh = true }
            end,
        },
        confirm = function(self, item)
            resession.load(item.file)
            self:close()
        end,
        win = {
            input = {
                keys = {
                    ["<C-d>"] = { "session_delete", mode = { "n", "i" } },
                },
            },
        },
    }
end

return M
