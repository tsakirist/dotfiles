local M = {}

function M.setup()
    local icons = require "tt.icons"

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

        ---whether to replace file icon with the modified symbol when buffer is modified
        ---@type boolean
        show_modified = true,

        symbols = {
            ---modification indicator
            ---`false` to disable
            ---@type false|string
            modified = icons.misc.Circle,

            ---truncation indicator
            ---@type string
            ellipsis = icons.misc.Ellipsis,

            ---entry separator
            ---@type string
            separator = icons.misc.ChevronRight,
        },

        ---icons for different context entry kinds
        ---`false` to disable kind icons
        ---@type table<string, string>|false
        kinds = icons.barbecue_kind,
    }
end

return M
