local M = {}

function M.setup()
    require("nvim-gps").setup {
        disable_icons = false, -- Setting it to true will disable all icons

        icons = {
            ["class-name"] = " ", -- Classes and class-like objects
            ["function-name"] = " ", -- Functions
            ["method-name"] = " ", -- Methods (functions inside class-like objects)
            ["container-name"] = "⛶ ", -- Containers (example: lua tables)
            ["tag-name"] = "炙", -- Tags (example: html tags)
        },

        -- Configuration per language basis
        languages = {
            -- Disable for particular languages
            -- ["bash"] = false, -- Disables nvim-gps for bash
        },

        -- The separator character to use
        separator = " > ",

        -- Limit for amount of context shown
        -- 0 means no limit
        -- Note: to make use of depth feature properly, make sure your separator isn't something that can appear
        -- in context names (eg: function names, class names, etc)
        depth = 0,

        -- Indicator used when context is hits depth limit
        depth_limit_indicator = "..",
    }
end

return M
