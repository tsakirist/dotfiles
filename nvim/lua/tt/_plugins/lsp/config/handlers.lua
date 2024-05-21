local M = {}

local function setup_diagnostics_config()
    local icons = require "tt.icons"

    vim.diagnostic.config {
        underline = true,
        severity_sort = true,
        virtual_lines = false,
        virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = icons.misc.ArrowRight,
        },
        update_in_insert = false,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
                [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
                [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
                [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
            },
        },
        float = {
            show_header = true,
            source = "if_many",
            border = "rounded",
            focusable = false,
            severity_sort = true,
        },
    }
end

local function setup_diagnostics_toggle()
    --- The record of the last displayed notification
    local diagnostics_notification = nil

    --- Function that toggles diagnostics on or off, for either all or the current buffer.
    --- Any argument that is supplied will indicate current buffer only mode.
    local function toggle_diagnostics(opts)
        local current_buffer = opts.args ~= ""
        local args = {
            bufnr = current_buffer and 0 or nil,
        }

        vim.diagnostic.enable(not vim.diagnostic.is_enabled(args), args)

        diagnostics_notification = vim.notify(
            string.format(
                "Diagnostics %s %s!",
                vim.diagnostic.is_enabled(args) and "enabled" or "disabled",
                current_buffer and "for current buffer" or "for all buffers"
            ),
            vim.log.levels.INFO,
            {
                title = "Diagnostics",
                replace = diagnostics_notification,
                on_close = function()
                    diagnostics_notification = nil
                end,
            }
        )
    end

    -- Add a command to toggle the diagnostics
    vim.api.nvim_create_user_command("ToggleDiagnostics", toggle_diagnostics, {
        desc = "Toggles diagnostics on and off, for all/current buffer(s)",
        nargs = "?",
    })
end

local function setup_diagnostics()
    setup_diagnostics_config()
    setup_diagnostics_toggle()
end

local function setup_hover()
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })
end

local function setup_definition()
    -- Make LSP handler for definitions to jump directly to the first available result
    vim.lsp.handlers["textDocument/definition"] = function(err, result, ctx, _)
        local title = "LSP definition"
        if err then
            vim.notify(err.message, vim.log.levels.ERROR, { title = title })
            return
        end
        if not result then
            vim.notify("Location not found", vim.log.levels.INFO, { title = title })
            return
        end

        local client_encoding = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding
        if vim.islist(result) and result[1] then
            vim.lsp.util.jump_to_location(result[1], client_encoding)
        else
            vim.lsp.util.jump_to_location(result, client_encoding)
        end
    end
end

function M.setup()
    setup_diagnostics()
    setup_hover()
    setup_definition()
end

return M
