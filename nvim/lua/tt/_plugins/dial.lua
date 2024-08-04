local M = {}

function M.setup()
    local augend = require "dial.augend"

    require("dial.config").augends:register_group {
        tt = {
            augend.constant.new {
                elements = { "and", "or" },
                word = true,
                cyclic = true,
            },
            augend.constant.new {
                elements = { "True", "False" },
                word = true,
                cyclic = true,
            },
            augend.constant.new {
                elements = { "public", "protected", "private" },
                word = true,
                cyclic = true,
            },
            augend.constant.new {
                elements = { "&&", "||" },
                word = false,
                cyclic = true,
            },
            augend.constant.new {
                -- stylua: ignore
                elements = { "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth" },
                word = false,
                cyclic = true,
            },
            augend.integer.alias.decimal,
            augend.integer.alias.hex,
            augend.integer.alias.binary,
            augend.constant.alias.bool,
            augend.semver.alias.semver,
            augend.date.alias["%d/%m/%Y"],
        },
        case = {
            augend.case.new {
                types = { "camelCase", "PascalCase", "snake_case", "SCREAMING_SNAKE_CASE" },
                cyclic = true,
            },
        },
    }

    --- Helper function to enhance dial mappings by preserving the cursor position.
    local function dial_action(action, mode, group)
        return function()
            require("tt.helper").preserve_cursor_position(function()
                require("dial.map").manipulate(action, mode, group)
            end)
        end
    end

    local utils = require "tt.utils"
    utils.map("n", "<C-a>", dial_action("increment", "normal", "tt"), { desc = "Enhanced increment" })
    utils.map("n", "<C-x>", dial_action("decrement", "normal", "tt"), { desc = "Enhanced decrement" })
    utils.map("v", "<C-a>", dial_action("increment", "visual", "tt"), { desc = "Enhanced increment" })
    utils.map("v", "<C-x>", dial_action("decrement", "visual", "tt"), { desc = "Enhanced decrement" })

    utils.map("n", "c<C-a>", dial_action("increment", "normal", "case"), { desc = "Enhanced increment case" })
    utils.map("n", "c<C-x>", dial_action("decrement", "normal", "case"), { desc = "Enhanced decrement case" })
end

return M
