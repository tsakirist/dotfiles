local M = {}

function M.setup()
    require("lsp-inlayhints").setup {
        inlay_hints = {
            parameter_hints = {
                show = true,
                prefix = "<- ",
                separator = ", ",
                remove_colon_start = true,
                remove_colon_end = true,
            },
            type_hints = {
                show = true,
                prefix = "",
                separator = ", ",
                remove_colon_start = false,
                remove_colon_end = false,
            },
            only_current_line = false,
            labels_separator = "  ",
            max_len_align = false,
            max_len_align_padding = 1,
            highlight = "LspInlayHint",
        },
        enabled_at_startup = true,
        debug_mode = false,
    }

    local utils = require "tt.utils"
    utils.map("n", "<leader>it", require("lsp-inlayhints").toggle, { desc = "Toggle LSP inlay hints" })
end

return M
