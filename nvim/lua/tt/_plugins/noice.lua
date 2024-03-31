local M = {}

function M.setup()
    local icons = require "tt.icons"

    require("noice").setup {
        cmdline = {
            view = "cmdline",
            format = {
                lua = {
                    view = "cmdline_popup",
                },
                filter = {
                    view = "cmdline_popup",
                    title = " Shell ",
                },
                IncRename = {
                    view = "cmdline_popup",
                    icon = icons.misc.Edit,
                    title = "Rename",
                },
            },
        },
        lsp = {
            signature = {
                auto_open = {
                    enabled = false,
                },
            },
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        routes = {
            {
                filter = {
                    event = "msg_show",
                    any = {
                        { find = "^/%w+" },
                        { find = "lines" },
                    },
                },
                view = "mini",
            },
            {
                filter = {
                    event = "msg_show",
                    any = {
                        { kind = "", find = "written" },
                        { find = "^E%w+" },
                        { find = "; after #%d+" },
                        { find = "; before #%d+" },
                    },
                },
                opts = {
                    skip = true,
                },
            },
        },
        presets = {
            bottom_search = true, -- Use a classic bottom cmdline for search
            command_palette = false, -- Position the cmdline and popupmenu together
            long_message_to_split = true, -- Long messages will be sent to a split
            lsp_doc_border = true, -- Add border to lsp hover and signature
            inc_rename = true, -- Add popup input dialog for 'inc-rename'
        },
    }

    local utils = require "tt.utils"

    utils.map("n", "<C-d>", function()
        if not require("noice.lsp").scroll(4) then
            return "<C-d>zz"
        end
    end, { expr = true, desc = "Scroll window downwards" })

    utils.map("n", "<C-u>", function()
        if not require("noice.lsp").scroll(-4) then
            return "<C-u>zz"
        end
    end, { expr = true, desc = "Scroll window upwards" })
end

return M
