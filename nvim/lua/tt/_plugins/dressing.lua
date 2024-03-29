local M = {}

function M.setup()
    require("dressing").setup {
        input = {
            -- Where to align the prompt, can be 'left', 'right', 'center'
            prompt_align = "center",

            -- Highlights: 'NormalFloat' for the text, 'FloatBorder' for the border
            win_options = {
                winhighlight = "FloatBorder:DressingBorder",
            },

            -- Make ui.input centered by default
            relative = "editor",
        },
    }
end

return M
