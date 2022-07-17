local M = {}

function M.setup()
    require("nvim-surround").setup {
        keymaps = {
            insert = "ys",
            insert_line = "yss",
            visual = "S",
            delete = "ds",
            change = "cs",
        },
        delimiters = {
            invalid_key_behavior = function()
                vim.api.nvim_err_writeln "Error: Invalid character!"
            end,
            pairs = {
                ["("] = { "( ", " )" },
                [")"] = { "(", ")" },
                ["{"] = { "{ ", " }" },
                ["}"] = { "{", "}" },
                ["<"] = { "< ", " >" },
                [">"] = { "<", ">" },
                ["["] = { "[ ", " ]" },
                ["]"] = { "[", "]" },
                -- Define pairs based on function evaluations!
                ["i"] = function()
                    return {
                        require("nvim-surround.utils").get_input "Enter left delimiter: ",
                        require("nvim-surround.utils").get_input "Enter right delimiter: ",
                    }
                end,
                ["f"] = function()
                    return {
                        require("nvim-surround.utils").get_input "Enter function name: " .. "(",
                        ")",
                    }
                end,
            },
            separators = {
                ["'"] = { "'", "'" },
                ['"'] = { '"', '"' },
                ["`"] = { "`", "`" },
            },
            HTML = {
                ["t"] = "type", -- Change just the tag type
                ["T"] = "whole", -- Change the whole tag contents
            },
            aliases = {
                ["a"] = ">", -- Single character aliases apply everywhere
                ["b"] = ")",
                ["B"] = "}",
                ["r"] = "]",
                -- Table aliases only apply for changes/deletions
                ["q"] = { '"', "'", "`" }, -- Any quote character
                ["s"] = { ")", "]", "}", ">", "'", '"', "`" }, -- Any surrounding delimiter
            },
        },
        highlight_motion = {
            duration = 0, -- '0' value indicates that highlighting will persist until operation completes or cancels
        },
    }
end

return M
