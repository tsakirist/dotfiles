local M = {}

function M.setup()
    require("git-conflict").setup {
        default_mappings = false, -- Whether or not to use default mappings
        disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
        highlights = { -- They must have background color, otherwise the default color will be used
            incoming = "DiffText",
            current = "DiffAdd",
        },
    }

    local utils = require "tt.utils"
    utils.map("n", "<leader>co", "<Plug>(git-conflict-ours)")
    utils.map("n", "<leader>ct", "<Plug>(git-conflict-theirs)")
    utils.map("n", "<leader>cb", "<Plug>(git-conflict-both)")
    utils.map("n", "<leader>cn", "<Plug>(git-conflict-none)")
    utils.map("n", "<leader>[c", "<Plug>(git-conflict-prev-conflict)")
    utils.map("n", "<leader>]c", "<Plug>(git-conflict-next-conflict)")
end

return M
