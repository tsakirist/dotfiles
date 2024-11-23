local M = {}

local resession = require "resession"

local last_session_name = "last_session"

local function setup_autocommands()
    vim.api.nvim_create_autocmd("VimLeavePre", {
        group = vim.api.nvim_create_augroup("tt.Resession", { clear = true }),
        callback = function()
            resession.save(last_session_name)
        end,
        desc = "Save session when exiting neovim",
    })
end

local function setup_commands()
    local cmds = {
        {
            name = "SSave",
            command = function(event)
                local session_name = event.fargs[1]
                resession.save(session_name)
            end,
            opts = { nargs = "?" },
        },
        {
            name = "SDelete",
            command = function(event)
                local session_name = event.fargs[1]
                resession.delete(session_name)
            end,
            opts = { nargs = "?" },
        },
        {
            name = "SLoad",
            command = function()
                resession.load()
            end,
        },
        {
            name = "SLast",
            command = function()
                resession.load(last_session_name)
            end,
        },
    }

    for _, cmd in ipairs(cmds) do
        vim.api.nvim_create_user_command(cmd.name, cmd.command, cmd.opts or {})
    end
end

function M.setup()
    resession.setup {
        -- The directory for saving sessions, located within stdpath("data")
        dir = "sessions/resession",

        -- Autosave the attached session periodically
        autosave = {
            enabled = true,
            interval = 60,
        },
    }

    setup_autocommands()
    setup_commands()
end

return M
