require("Comment").setup {
    ---Add a space b/w comment and the line
    ---@type boolean
    padding = true,

    ---Whether the cursor should stay at its position
    ---NOTE: This only affects NORMAL mode mappings and doesn't work with dot-repeat
    ---@type boolean
    sticky = true,

    ---Lines to be ignored while comment/uncomment
    ---Could be a regex string or a function that returns a regex string
    ---@type string|function
    ignore = "^$",

    ---Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
    ---@type table
    mappings = {
        ---operator-pending mapping
        ---Includes `gcc`, `gcb`, `gc[count]{motion}` and `gb[count]{motion}`
        basic = true,
        ---extra mapping
        ---Includes `gco`, `gcO`, `gcA`
        extra = true,
        ---extended mapping
        ---Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
        extended = false,
    },

    ---LHS of toggle mapping in NORMAL + VISUAL mode
    ---@type table
    toggler = {
        ---line-comment keymap
        line = "gcc",
        ---block-comment keymap
        block = "gbc",
    },

    ---LHS of operator-pending mapping in NORMAL + VISUAL mode
    ---@type table
    opleader = {
        ---line-comment keymap
        line = "gc",
        ---block-comment keymap
        block = "gb",
    },

    ---Pre-hook, called before commenting the line
    ---@type function|nil
    pre_hook = function(ctx)
        local U = require "Comment.utils"

        -- Detemine whether to use linewise or blockwise commentstring
        local type = ctx.ctype == U.ctype.line and "__default" or "__multiline"

        -- Determine the location where to calculate commentstring from
        local location = nil
        if ctx.ctype == U.ctype.block then
            location = require("ts_context_commentstring.utils").get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require("ts_context_commentstring.utils").get_visual_start_location()
        end

        return require("ts_context_commentstring.internal").calculate_commentstring {
            key = type,
            location = location,
        }
    end,

    ---Post-hook, called after commenting is done
    ---@type function|nil
    post_hook = nil,
}

-- Setup Comment keymappings
local utils = require "tt.utils"

utils.map("n", "<leader><leader>", "gcc", { noremap = false })
utils.map("v", "<leader><leader>", "gc", { noremap = false })
utils.map("i", "<leader><leader>", "<C-o><Cmd>lua require'Comment'.toggle()<CR>")
