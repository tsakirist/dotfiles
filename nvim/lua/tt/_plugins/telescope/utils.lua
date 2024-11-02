local actions_state = require "telescope.actions.state"

local M = {}

--- Returns the picker associated with the current buffer.
---@param buffer? number: The buffer from which to get the picker from.
---@return table: The picker associated with the current buffer.
function M.get_current_picker(buffer)
    buffer = buffer or vim.api.nvim_get_current_buf()
    local current_picker = actions_state.get_current_picker(buffer)
    return current_picker
end

--- Returns the preview window associated with the picker.
---@param picker? table: The picker object.
---@return number: The preview window associated with the picker.
function M.get_picker_preview_window(picker)
    picker = picker or M.get_current_picker()
    local preview_window = picker.preview_win
    return preview_window
end

return M
