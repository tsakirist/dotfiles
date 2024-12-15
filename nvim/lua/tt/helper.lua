local M = {}

--- Function to zoom-in and zoom-out of the given window in a new tab.
local function zoom_toggle_new_tab()
    local zoomed_window_id = "zoomed_window"

    -- Do not open new tab for unnamed buffer
    local buf_name = vim.api.nvim_buf_get_name(0)
    if buf_name == "" then
        return
    end

    -- Get the windows in the current tab, excluding those with filetypes listed in `excluded_filetypes`
    local function get_tab_windows()
        local excluded_filetypes = { ["smear-cursor"] = true, snacks_notif = true, noice = true }
        local tab_windows = vim.api.nvim_tabpage_list_wins(0)
        return vim.iter(tab_windows)
            :filter(function(window)
                local buf = vim.api.nvim_win_get_buf(window)
                local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
                return not excluded_filetypes[ft]
            end)
            :totable()
    end

    -- Do not open if it's the only window in the current tab
    local tab_windows = get_tab_windows()
    if #tab_windows == 1 then
        -- Close the tab only if it's opened by this function
        if pcall(vim.api.nvim_tabpage_get_var, 0, zoomed_window_id) then
            vim.cmd.tabclose()
        end
    else
        -- Open a new tab with the current file
        vim.cmd.tabnew(buf_name)
        -- Set a tab local variable indicating that we're in a "zoomed" window
        vim.api.nvim_tabpage_set_var(0, zoomed_window_id, true)
    end
end

--- Function to zoom-in and zoom-out of the given window in a new tab,
--- whilst also preserving the cursor position.
function M.zoom_toggle_new_tab()
    M.preserve_cursor_position(zoom_toggle_new_tab)
end

--- Function to trim trailing whitespace.
function M.trim_trailing_white_space()
    local savedView = vim.fn.winsaveview()
    vim.cmd [[keeppatterns %s/\s\+$//e]]
    vim.fn.winrestview(savedView)
end

--- Function to copy the filename according to the supplied modifier
--- to the system's clipboard.
---@param modifier string: The modifier to use for the filename
function M.copy_filename_to_clipboard(modifier)
    local filename = vim.fn.expand("%:" .. modifier)
    if filename ~= "" then
        vim.fn.setreg("+", filename)
        vim.notify(
            ("Copied '%s' to system clipboard!"):format(filename),
            vim.log.levels.INFO,
            { title = "Copy filename to clipboard" }
        )
    end
end

--- Preserves cursor position upon invocation of the supplied cmd.
---@param arg string|function: The command|function to execute.
function M.preserve_cursor_position(arg)
    local last_cursor_pos = vim.api.nvim_win_get_cursor(0)
    if type(arg) == "function" then
        arg()
    elseif type(arg) == "string" then
        vim.cmd(arg)
    end
    vim.api.nvim_win_set_cursor(0, last_cursor_pos)
end

--- Returns the start and end position of the current visual selection.
---@return { start_pos:number, end_pos:number}
function M.get_visual_selection()
    local visual_range = { start_pos = vim.fn.line "v", end_pos = vim.fn.line "." }
    if visual_range.start_pos > visual_range.end_pos then
        local tmp = visual_range.start_pos
        visual_range.start_pos = visual_range.end_pos
        visual_range.end_pos = tmp
    end
    return visual_range
end

return M
