local status_ok, lsp_inlay_hints = pcall(require, "lsp-inlayhints")

if not status_ok then
    return
end

local M = {}

local function setup_autocommands()
    local group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
    vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(args)
            if not (args.data and args.data.client_id) then
                return
            end

            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            lsp_inlay_hints.on_attach(client, bufnr)
        end,
    })
end

function M.setup()
    setup_autocommands()

    lsp_inlay_hints.setup {
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
    utils.map("n", "<leader>ht", function()
        lsp_inlay_hints.toggle()
    end, { desc = "Toggle LSP inlay hints" })
end

return M
