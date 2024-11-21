local M = {}

local function fold_virtual_text_handler(virtText, lnum, endLnum, width, truncate)
    local icons = require "tt.icons"

    local foldedLines = endLnum - lnum
    local text = string.format(" %s %d lines", icons.misc.ArrowSouthWest, foldedLines)
    local textWidth = vim.fn.strdisplaywidth(text)
    local targetWidth = width - textWidth
    local curWidth = 0
    local virtualText = {}

    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(virtualText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(virtualText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
                text = text .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end

    table.insert(virtualText, { text, "MoreMsg" })

    return virtualText
end

local function set_autocommands()
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("tt.Ufo", { clear = true }),
        pattern = require("tt.common").ignored_filetypes,
        callback = function()
            require("ufo").detach()
        end,
        desc = "Exclude UFO on certain filetypes",
    })
end

function M.init()
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldcolumn = "1"
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
end

function M.setup()
    local ufo = require "ufo"

    ufo.setup {
        open_fold_hl_timeout = 400,
        close_fold_kinds_for_ft = {
            default = {
                "imports",
                "comment",
            },
            c = {
                "comment",
                "region",
            },
        },
        preview = {
            win_config = {
                border = { "", "─", "", "", "", "─", "", "" },
                winhighlight = "Normal:Folded",
                winblend = 0,
            },
            mappings = {
                scrollU = "<C-u>",
                scrollD = "<C-d>",
                jumpTop = "[",
                jumpBot = "]",
                close = "<Esc>",
            },
        },
        fold_virt_text_handler = fold_virtual_text_handler,
        enable_get_fold_virt_text = false,
    }

    set_autocommands()

    local utils = require "tt.utils"
    utils.map("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
    utils.map("n", "zr", ufo.openFoldsExceptKinds, { desc = "Open all folds except kinds" })
    utils.map("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
    utils.map("n", "zm", ufo.closeFoldsWith, { desc = "Close all folds with fold level 0" })
    utils.map("n", "zj", ufo.goNextClosedFold, { desc = "Go to next closed fold" })
    utils.map("n", "zk", ufo.goPreviousClosedFold, { desc = "Go to previous closed fold" })

    utils.map("n", "<F3>", ufo.openAllFolds, { desc = "Open all folds" })
    utils.map("n", "<F4>", ufo.closeAllFolds, { desc = "Close all folds" })

    utils.map("n", "zp", function()
        local winid = ufo.peekFoldedLinesUnderCursor()
        if not winid then
            vim.lsp.buf.hover()
        end
    end, { desc = "Peek folded lines under cursor" })

    for i = 1, 4 do
        utils.map("n", "z" .. i, function()
            ufo.closeFoldsWith(i)
        end, { desc = " Close L" .. i .. " folds" })
    end

    utils.map("n", "<leader>ut", function()
        vim.cmd.UfoDetach()
        vim.cmd.UfoAttach()
    end, { desc = "Detach/Re-attach UFO" })
end

return M
