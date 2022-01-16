local M = {}

---Function to zoom-in and zoom-out from a window
---@deprecated in favor of 'zoomToggleNewTab'
function M.zoomToggleSameTab()
    -- Do nothing if this is the only window, i.e. no splits
    if vim.fn.winnr "$" == 1 then
        return nil
    end

    if vim.t.zoomed then
        -- Restore the window to its original dimensions
        vim.cmd [[execute t:zoom_restore_cmd]]
        vim.t.zoomed = false
    else
        vim.t.zoomed = true
        -- Returns a sequence of :resize commands that should
        -- restore the current window sizes
        vim.t.zoom_restore_cmd = vim.fn.winrestcmd()
        -- Maximize the current window
        vim.cmd [[
            wincmd _
            wincmd |
        ]]
    end
end

---Function to zoom-in and zoom-out of the given window in a new tab
---that also retains cursor position when zooming-in and zooming-out
function M.zoomToggleNewTab()
    -- Do nothing if this is the only window in the first tab
    if vim.fn.winnr "$" == 1 and vim.fn.tabpagenr "$" == 1 then
        return
    end

    -- Get the last cursor position before opening the new tab
    local last_cursor = vim.api.nvim_win_get_cursor(0)

    if vim.fn.winnr "$" == 1 then
        -- Close the tab only if it's opened by this function
        if pcall(vim.api.nvim_tabpage_get_var, 0, "zoomedTab") then
            vim.cmd [[ tabclose ]]
        end
    else
        -- Open a new tab with the current file
        vim.cmd [[ tabnew %:p ]]
        -- Set a t:_zoomed indicating if we're on a "zoomed" tab
        vim.api.nvim_tabpage_set_var(0, "zoomedTab", true)
    end

    -- Restore the cursor position
    vim.api.nvim_win_set_cursor(0, last_cursor)
end

---Function to trim trailing whitespace
function M.trimTrailingWhiteSpace()
    local savedView = vim.fn.winsaveview()
    vim.cmd [[keeppatterns %s/\s\+$//e]]
    vim.fn.winrestview(savedView)
end

return M
