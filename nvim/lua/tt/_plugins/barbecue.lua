local M = {}

function M.setup()
    local icons = require "tt.icons"

    require("barbecue").setup {
        ---Whether to attach navic to language servers automatically.
        ---@type boolean
        attach_navic = true,

        ---Whether to show/use navic in the winbar.
        ---@type boolean
        show_navic = true,

        ---Whether to create winbar updater autocmd.
        ---@type boolean
        create_autocmd = true,

        ---Buftypes to enable winbar in.
        ---@type string[]
        include_buftypes = { "" },

        ---Filetypes not to enable winbar in.
        ---@type string[]
        exclude_filetypes = { "gitcommit", "toggleterm" },

        modifiers = {
            ---Filename modifiers applied to dirname.
            ---See: `:help filename-modifiers`
            ---@type string
            dirname = ":~:.",

            ---Filename modifiers applied to basename.
            ---See: `:help filename-modifiers`
            ---@type string
            basename = "",
        },

        ---Returns a string to be shown at the start of winbar.
        ---@type fun(bufnr: number): string
        lead_custom_section = function()
            return ""
        end,

        ---Returns a string to be shown at the end of winbar.
        ---@type fun(bufnr: number): string
        custom_section = function()
            return ""
        end,

        ---`auto` uses your current colorscheme's theme or generates a theme based on it
        ---`string` is the theme name to be used (theme should be located under `barbecue.theme` module)
        ---`barbecue.Theme` is a table that overrides the `auto` theme detection/generation
        ---@alias barbecue.Theme table<string, table>
        ---@type "auto"|string|barbecue.Theme
        theme = "auto",

        ---Whether to replace file icon with the modified symbol when buffer is
        ---modified.
        ---@type boolean
        show_modified = true,

        ---Get modified status of file.
        ---@type fun(bufnr: number): boolean
        modified = function(bufnr)
            return vim.bo[bufnr].modified
        end,

        ---Whether context text should follow its icon's color.
        ---@type boolean
        context_follow_icon_color = false,

        symbols = {
            ---modification indicator
            ---@type string
            modified = icons.misc.Circle,

            ---truncation indicator
            ---@type string
            ellipsis = icons.misc.Ellipsis,

            ---entry separator
            ---@type string
            separator = icons.misc.ChevronRight,
        },

        ---@alias barbecue.Config.kinds
        ---|false # Disable kind icons.
        ---|table<string, string> # Type to icon mapping.
        ---
        ---Icons for different context entry kinds.
        ---@type barbecue.Config.kinds
        kinds = icons.breadcrumps,
    }
end

return M
