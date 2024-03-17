local M = {}

function M.setup()
    local icons = require "tt.icons"

    require("nvim-navic").setup {
        -- Use highlights or not
        highlight = true,

        -- The separator character to use
        separator = " > ",

        -- Limit for amount of context shown
        -- 0 means no limit
        -- Note: to make use of depth feature properly, make sure your separator isn't something that can appear
        -- in context names (eg: function names, class names, etc)
        depth_limit = 0,

        -- Indicator used when context is hits depth limit
        depth_limit_indicator = "..",

        -- The icons to use
        icons = icons.breadcrumps,
    }
end

return M
