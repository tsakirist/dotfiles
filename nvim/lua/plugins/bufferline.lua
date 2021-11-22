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
        left_mouse_command = "buffer %d", -- change to buffer on left click
        right_mouse_command = "vertical sbuffer %d", -- open a vertical split on right click
        middle_mouse_command = "bdelete! %d", -- close the buffer on middle click
        separator_style = "thin", -- options are: 'slant', 'padded-slant', 'thick', 'thin'
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false, -- shows an 'x' icon in right corner
        show_tab_indicators = true,
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        max_name_length = 20,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        tab_size = 25,
        offsets = { -- apply an offset for sidebar windows
            { filetype = "NvimTree", text = "File Explorer", highlight = "Directory", text_align = "center" },
        },
        diagnostics = false, -- whether or not to show lsp diagnostics
    },
}
