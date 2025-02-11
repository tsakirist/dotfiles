local M = {}

---@type table<string, snacks.win.Config>
M.styles = {
    notification = {
        wo = {
            wrap = true,
        },
        relative = "editor",
    },
    notification_history = {
        width = 0.75,
        height = 0.75,
        relative = "editor",
    },
    scratch = {
        width = 0.70,
        height = 0.65,
        relative = "editor",
    },
}

return M
