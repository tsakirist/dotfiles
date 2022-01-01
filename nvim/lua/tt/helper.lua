local helper = {}

-- Function to zoom-in and zoom-out from a window
function helper.zoomToggle()
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

-- Function to trim trailing whitespace
function helper.trimTrailingWhiteSpace()
    local save = vim.fn.winsaveview()
    vim.cmd [[keeppatterns %s/\s\+$//e]]
    vim.fn.winrestview(save)
end

return helper
