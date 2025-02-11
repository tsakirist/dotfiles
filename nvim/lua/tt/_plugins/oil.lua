local M = {}

--- Helper variable for toggling Oil detailed view
local detailed_view = false

--- Function for toggling Oil detailed view
local function show_detailed_view()
    detailed_view = not detailed_view
    if detailed_view then
        require("oil").set_columns { "icon", "permissions", "size", "mtime" }
    else
        require("oil").set_columns { "icon" }
    end
end

function M.setup()
    ---@type oil.SetupOpts
    require("oil").setup {
        skip_confirm_for_simple_edits = true,
        win_options = {
            wrap = true,
            winbar = "%{v:lua.GetOilWinbar()}", -- Set in globals.lua
        },
        use_default_keymaps = false,
        preview_win = {
            preview_method = "load",
        },
        float = {
            padding = 0,
            get_win_title = function()
                return ""
            end,
        },
        keymaps = {
            ["g?"] = "actions.show_help",
            ["<CR>"] = "actions.select",
            ["."] = "actions.select",
            ["="] = "actions.select",
            ["+"] = "actions.select",
            [">"] = "actions.select",
            ["<"] = "actions.parent",
            ["-"] = "actions.parent",
            ["_"] = "actions.open_cwd",
            ["<C-c>d"] = "actions.cd",
            ["gs"] = "actions.change_sort",
            ["gx"] = "actions.open_external",
            ["gd"] = {
                callback = show_detailed_view,
                desc = "Toggle file detailed view",
            },
            ["g\\"] = "actions.toggle_trash",
            ["H"] = "actions.toggle_hidden",
            ["P"] = "actions.preview",
            ["<C-v>"] = {
                "actions.select",
                opts = { vertical = true },
                desc = "Open the entry in a vertical split",
            },
            ["<C-x>"] = {
                "actions.select",
                opts = { horizontal = true },
                desc = "Open the entry in a horizontal split",
            },
            ["<C-t>"] = {
                "actions.select",
                opts = { tab = true },
                desc = "Open the entry in new tab",
            },
            ["<C-d>"] = "actions.preview_scroll_down",
            ["<C-u>"] = "actions.preview_scroll_up",
            ["<C-l>"] = "actions.refresh",
            ["<C-q>"] = "actions.close",
            ["q"] = "actions.close",
        },
    }

    local utils = require "tt.utils"
    utils.map("n", "<leader>e", function()
        local open_method = vim.v.count == 0 and require("oil").open or require("oil").open_float
        open_method()
    end, { desc = "Open Oil file explorer. If a count is passed it opens in floating mode." })
end

return M
