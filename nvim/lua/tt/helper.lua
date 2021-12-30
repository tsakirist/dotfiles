local helper = {}

-- TODO: Fix or implement this?
function helper.zoomToggle()
    vim.fn.ZoomToggle()
end

---Function to trim trailing whitespace
function helper.trimTrailingWhiteSpace()
    local save = vim.fn.winsaveview()
    vim.cmd [[keeppatterns %s/\s\+$//e]]
    vim.fn.winrestview(save)
end

return helper
