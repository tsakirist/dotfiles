local M = {}

function M.setup()
    -- Module that shows the current cursor context
    local gps = require "nvim-gps"

    require("lualine").setup {
        options = {
            theme = "nightfox",
            icons_enabled = true,
        },
        sections = {
            lualine_c = {
                {
                    gps.get_location,
                    cond = gps.is_available,
                },
            },
        },
    }
end

return M
