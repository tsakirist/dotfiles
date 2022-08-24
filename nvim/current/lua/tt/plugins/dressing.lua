local M = {}

function M.setup()
    require("dressing").setup {
        input = {
            -- Required for 'inc-rename' to position the input
            -- box above the cursor to not cover the word being renamed
            override = function(conf)
                conf.col = -1
                conf.row = 0
                return conf
            end,
            winhighlight = "NormalFloat:DressingInput,FloatBorder:DressingBorder",
            -- Make ui.input centered by default
            relative = "editor",
            -- Override ui.input when renaming to be relative to cursor
            get_config = function(opts)
                _G.Print(opts.prompt)
                local is_renaming = opts.prompt == "New name: "
                if is_renaming then
                    return {
                        relative = "cursor",
                    }
                end
            end,
        },
    }
end

return M
