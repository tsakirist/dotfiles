local M = {}

function M.setup()
    local null_ls = require "null-ls"
    local null_ls_sources = require("tt._plugins.lsp.config.servers").null_ls_sources

    local final_sources = {}
    for type, sources in pairs(null_ls_sources) do
        if not vim.tbl_isempty(sources) then
            for source, extra_args in pairs(sources) do
                local final_source = null_ls.builtins[type][source].with(extra_args)
                table.insert(final_sources, final_source)
            end
        end
    end

    null_ls.setup { sources = final_sources }
end

return M
