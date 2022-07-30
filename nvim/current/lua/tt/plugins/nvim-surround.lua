local M = {}

-- Since `vim.fn.input()` does not handle keyboard interrupts, we use a protected call to check whether the user has
-- used `<C-c>` to cancel the input. This is not needed if `<Esc>` is used to cancel the input.
local get_input = function(prompt)
    local ok, result = pcall(vim.fn.input, { prompt = prompt })
    if not ok then
        return nil
    end
    return result
end

function M.setup()
    require("nvim-surround").setup {
        keymaps = {
            insert = "<C-g>s",
            insert_line = "<C-g>S",
            normal = "ys",
            normal_cur = "yss",
            normal_line = "yS",
            normal_cur_line = "ySS",
            visual = "S",
            visual_line = "gS",
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
                ["i"] = function()
                    local left_delimiter = get_input "Enter left delimiter: "
                    if left_delimiter then
                        local right_delimiter = get_input "Enter right delimiter: "
                        if right_delimiter then
                            return { left_delimiter, right_delimiter }
                        end
                    end
                end,
                ["f"] = function()
                    local function_name = get_input "Enter function name: "
                    if function_name then
                        return { function_name .. "(", ")" }
                    end
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
        move_cursor = "begin", -- Move cursor to the beginning of the surround
    }
end

return M
