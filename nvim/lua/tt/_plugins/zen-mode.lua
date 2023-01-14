local M = {}

function M.setup()
    require("zen-mode").setup {
        window = {
            backdrop = 1, -- Shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
            -- Height and width can be:
            -- * an absolute number of cells when > 1
            -- * a percentage of the width / height of the editor when <= 1
            -- * a function that returns the width or the height
            width = 0.66, -- Width of the Zen window
            height = 0.9, -- Height of the Zen window
            options = {
                signcolumn = "no", -- Disable signcolumn
                number = false, -- Disable number column
                relativenumber = false, -- Disable relative numbers
                -- cursorline = false, -- Disable cursorline
                -- cursorcolumn = false, -- Disable cursor column
                -- foldcolumn = "0", -- Disable fold column
                -- list = false, -- Disable whitespace characters
            },
        },
        plugins = {
            options = {
                enabled = true,
                ruler = false, -- Disables the ruler text in the cmd line area
                showcmd = false, -- Disables the command in the last line of the screen
            },
            twilight = { enabled = false }, -- Enable to start Twilight when zen mode opens
            gitsigns = { enabled = false }, -- Disables git signs
            -- This will change the font size on kitty when in zen mode
            -- To make this work, you need to set the following kitty options:
            -- - allow_remote_control socket-only
            -- - listen_on unix:/tmp/kitty
            kitty = {
                enabled = false,
                font = "+4", -- Font size increment
            },
        },
        -- Callback where you can add custom code when the Zen window opens
        on_open = function(_) end,
        -- Callback where you can add custom code when the Zen window closes
        on_close = function() end,
    }

    local utils = require "tt.utils"
    utils.map("n", "<F1>", "<Cmd>ZenMode<CR>", { desc = "Enable ZenMode" })
end

return M
