local M = {}

function M.setup()
    require("bufferline").setup {
        options = {
            numbers = function(opts)
                return string.format("%s", opts.id)
            end,
            indicator_icon = "▎",
            buffer_close_icon = "",
            modified_icon = "●",
            close_icon = "",
            left_trunc_marker = "",
            right_trunc_marker = "",
            close_command = "bdelete! %d",
            left_mouse_command = "buffer %d", -- Change to buffer on left click
            right_mouse_command = "vertical sbuffer %d", -- Open a vertical split on right click
            middle_mouse_command = "bdelete! %d", -- Close the buffer on middle click
            separator_style = "thin", -- Options are: 'slant', 'padded-slant', 'thick', 'thin'
            show_buffer_icons = true,
            show_buffer_close_icons = false,
            show_close_icon = false, -- Shows an 'x' icon in right corner
            show_tab_indicators = true,
            enforce_regular_tabs = true,
            always_show_bufferline = true,
            max_name_length = 20,
            max_prefix_length = 15, -- Prefix used when a buffer is de-duplicated
            tab_size = 25,
            offsets = { -- Apply an offset for sidebar windows
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    highlight = "Directory",
                    text_align = "center",
                },
                {
                    filetype = "vista_kind",
                    text = "Vista",
                    highlight = "Directory",
                    text_align = "right",
                },
            },
            diagnostics = false, -- Set to "nvim_lsp" for enabling LSP diagnostics
        },
        highlights = {
            buffer_selected = {
                gui = "bold",
            },
        },
    }
end

return M
