local previewers = require "telescope.previewers"

local M = {}

--- Custom previewers that can be used for telescope actions.
M.previewers = {
    delta = previewers.new_termopen_previewer {
        get_command = function(entry)
            return { "git", "diff", entry.value .. "^!" }
        end,
    },
}

return M
