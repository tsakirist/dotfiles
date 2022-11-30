local M = {}

function M.setup()
    local barbecue_kinds = require("tt.icons").barbecue

    require("barbecue").setup {
        ---whether to attach navic to language servers automatically
        ---@type boolean
        attach_navic = true,

        ---whether to create winbar updater autocmd
        ---@type boolean
        create_autocmd = true,

        ---buftypes to enable winbar in
        ---@type string[]
        include_buftypes = { "" },

        ---filetypes not to enable winbar in
        ---@type string[]
        exclude_filetypes = { "toggleterm", "gitcommit" },

        truncation = {
            ---whether winbar truncation is enabled
            ---`false` to gain a little performance
            ---@type boolean
            enabled = true,

            ---`simple` starts truncating from the beginning until it fits
            ---`keep_basename` is the same as `simple` but skips basename
            ---@type "simple"|"keep_basename"
            method = "keep_basename",
        },

        modifiers = {
            ---filename modifiers applied to dirname
            ---@type string
            dirname = ":~:.",

            ---filename modifiers applied to basename
            ---@type string
            basename = "",
        },

        ---returns a string to be shown at the end of winbar
        ---@type fun(bufnr: number): string
        custom_section = function()
            return ""
        end,

        symbols = {
            ---modification indicator
            ---`false` to disable
            ---@type false|string
            modified = false,

            ---truncation indicator
            ---@type string
            ellipsis = "…",

            ---entry separator
            ---@type string
            separator = "",
        },

        ---icons for different context entry kinds
        ---`false` to disable kind icons
        ---@type table<string, string>|false
        kinds = barbecue_kinds,
    }
end

return M
