local M = {}

function M.setup()
    require("dressing").setup {
        input = {
            -- Where to align the prompt, can be 'left', 'right', 'center'
            prompt_align = "center",

            -- Highlights: 'NormalFloat' for the text, 'FloatBorder' for the border
            winhighlight = "FloatBorder:DressingBorder",

            -- Make ui.input centered by default
            relative = "editor",

            -- Override ui.input when renaming to be relative to cursor
            get_config = function(opts)
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
