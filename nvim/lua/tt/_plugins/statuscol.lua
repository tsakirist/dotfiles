local M = {}

function M.setup()
    local builtin = require "statuscol.builtin"

    require("statuscol").setup {
        relculright = true,
        segments = {
            { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
            { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            {
                sign = { namespace = { "diagnostic" } },
                condition = {
                    function()
                        -- Show segment only when there are diagnostics available
                        return next(vim.diagnostic.count(0)) ~= nil
                    end,
                },
                click = "v:lua.ScSa",
            },
        },
        ft_ignore = require("tt.common").ignored_filetypes,
    }
end

return M
