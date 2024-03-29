local M = {}

--- Function to zoom-in and zoom-out from a window.
---@deprecated in favor of 'zoomToggleNewTab'
function M.zoom_toggle_same_tab()
    -- Do nothing if this is the only window, i.e. no splits
    if vim.fn.winnr "$" == 1 then
        return nil
    end

    if vim.t.zoomed then
        -- Restore the window to its original dimensions
        vim.cmd.execute "t:zoom_restore_cmd"
        vim.t.zoomed = false
    else
        vim.t.zoomed = true
        -- Returns a sequence of :resize commands that should
        -- restore the current window sizes
        vim.t.zoom_restore_cmd = vim.fn.winrestcmd()
        -- Maximize the current window
        vim.cmd.wincmd "_"
        vim.cmd.wincmd "|"
    end
end

--- Function to zoom-in and zoom-out of the given window in a new tab.
local function zoom_toggle_new_tab()
    -- Do not open new tab for unnamed buffer
    -- TODO: Think how this can be fixed
    if vim.fn.bufname() == "" then
        return
    end

    -- Do nothing if this is the only window in the first tab
    if vim.fn.winnr "$" == 1 and vim.fn.tabpagenr "$" == 1 then
        return
    end

    if vim.fn.winnr "$" == 1 then
        -- Close the tab only if it's opened by this function
        if pcall(vim.api.nvim_tabpage_get_var, 0, "zoomedTab") then
            vim.cmd.tabclose()
        end
    else
        -- Open a new tab with the current file
        vim.cmd.tabnew "%:p"
        -- Set a tab local variable indicating that we're in a "zoomed" tab
        vim.api.nvim_tabpage_set_var(0, "zoomedTab", true)
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
