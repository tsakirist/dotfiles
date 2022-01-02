local M = {}

function M.setup()
    require("nvim-autopairs").setup {
        disable_filetype = { "TelescopePrompt", "vim" },
        check_ts = true,
    }

    -- Fix <CR> for nvim-cmp
    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    local cmp = require "cmp"
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
end

return M
