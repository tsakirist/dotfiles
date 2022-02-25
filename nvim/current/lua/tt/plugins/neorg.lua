local M = {}

function M.setup()
    require("neorg").setup {
        load = {
            -- Load default modules
            ["core.defaults"] = {},
            -- Module for keybinds
            ["core.keybinds"] = {
                config = {
                    hook = function(keybinds)
                        -- Unmap <C-s> because it's used for saving the buffer
                        keybinds.unmap("norg", "n", "<C-s>")
                    end,
                },
            },
            -- Module that enables Table of Contents (TOC) generation
            ["core.norg.qol.toc"] = {},
            -- Module that enables icons to be used
            ["core.norg.concealer"] = {},
            -- Module to enable source completion
            ["core.norg.completion"] = {
                config = {
                    engine = "nvim-cmp",
                },
            },
            -- Module to allow workspace management
            ["core.norg.dirman"] = {
                config = {
                    workspaces = {
                        scratch = "~/Documents/notes/scratch",
                        work = "~/Documents/notes/work",
                    },
                },
            },
        },
    }
end

return M
