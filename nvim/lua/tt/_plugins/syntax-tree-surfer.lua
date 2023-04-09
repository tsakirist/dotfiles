local M = {}

function M.setup()
    require("syntax-tree-surfer").setup()

    local utils = require "tt.utils"

    --- Swapping keymaps in normal mode
    utils.map("n", "<M-J>", function()
        vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
        return "g@l"
    end, { expr = true, desc = "Swap master node with next sibling" })

    utils.map("n", "<M-K>", function()
        vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
        return "g@l"
    end, { expr = true, desc = "Swap master node with previous sibling" })

    utils.map("n", "<M-j>", function()
        vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
        return "g@l"
    end, { expr = true, desc = "Swap current node with next sibling" })

    utils.map("n", "<M-k>", function()
        vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
        return "g@l"
    end, { expr = true, desc = "Swap current node with previous sibling" })

    --- Swapping keymaps in visual mode
    utils.map("x", "<M-j>", "<Cmd>STSSwapNextVisual<CR>")
    utils.map("x", "<M-k>", "<Cmd>STSSwapPrevVisual<CR>")

    --- Visual selection from normal mode
    utils.map("n", "vm", "<Cmd>STSSelectMasterNode<CR>")
    utils.map("n", "vn", "<Cmd>STSSelectCurrentNode<CR>")

    --- Select nodes in visual mode
    utils.map("x", "J", "<Cmd>STSSelectNextSiblingNode<CR>")
    utils.map("x", "K", "<Cmd>STSSelectPrevSiblingNode<CR>")
    utils.map("x", "H", "<Cmd>STSSelectParentNode<CR>")
    utils.map("x", "L", "<Cmd>STSSelectChildNode<CR>")

    --- Targeted jump with virtual text
    utils.map("n", "<leader>gt", function()
        require("syntax-tree-surfer").targeted_jump {
            "else_clause",
            "else_statement",
            "elseif_statement",
            "for_statement",
            "function",
            "function_definition",
            "if_statement",
            "switch_statement",
            "while_statement",
        }
    end, { desc = "Targeted jump to node with virtual text" })
end

return M
