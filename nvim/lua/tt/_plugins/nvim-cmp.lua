local deps_ok, cmp, luasnip, neogen = pcall(function()
    return require "cmp", require "luasnip", require "neogen"
end)

if not deps_ok then
    return
end

local M = {}

local icons = require "tt.icons"

-- Setup custom menu entries for the autocompletion
local cmp_source_names = {
    nvim_lsp = "[LSP]",
    nvim_lua = "[Lua]",
    luasnip = "[LuaSnip]",
    path = "[Path]",
    buffer = "[Buffer]",
}

-- Setup custom options for the pop-up windows
local cmp_window_opts = {
    border = "rounded",
    winhighlight = "Normal:NormalFloat,FloatBorder:CmpWindowBorder,CursorLine:CmpWindowCursorLine,Search:None",
}

-- Functions for mapping <Tab> and <S-Tab> for nvim-cmp
local function tab(fallback)
    local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
    end
    if cmp.visible() then
        cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    elseif neogen.jumpable() then
        neogen.jump_next()
    elseif has_words_before() then
        cmp.complete()
    else
        fallback()
    end
end

local function shift_tab(fallback)
    if cmp.visible() then
        cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
    elseif neogen.jumpable(-1) then
        neogen.jump_prev()
    else
        fallback()
    end
end

function M.setup()
    cmp.setup {
        view = {
            entries = {
                name = "custom",
                follow_cursor = true,
            },
        },
        completion = {
            -- The minimum length of a word to complete on
            keyword_length = 1,
        },
        experimental = {
            ghost_text = true,
        },
        formatting = {
            -- Whether to show the `~` on suggestions
            expandable_indicator = true,

            -- Set the ordering of the fields/items in the pop-up menu
            fields = { "kind", "abbr", "menu" },

            -- Set the format function that will be used for the suggestiosn
            format = function(entry, vim_item)
                -- Add icons for the suggestions
                vim_item.kind = icons.kind[vim_item.kind]

                -- Set a name for each source
                vim_item.menu = cmp_source_names[entry.source.name]

                -- Do not add duplicate entries if an item with the same word is already present
                -- Seems to fix, the duplicate entries with the snippets
                vim_item.dup = nil

                return vim_item
            end,
        },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        window = {
            completion = cmp.config.window.bordered(cmp_window_opts),
            documentation = cmp.config.window.bordered(cmp_window_opts),
        },
        mapping = cmp.mapping.preset.insert {
            ["<CR>"] = cmp.mapping.confirm { select = true },
            ["<Tab>"] = cmp.mapping(tab, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(shift_tab, { "i", "s" }),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-Space>"] = cmp.mapping.complete(),
        },
        preselect = cmp.PreselectMode.Item,
        sources = {
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "lazydev", group_index = 0 },
            { name = "luasnip" },
            { name = "path" },
            {
                name = "buffer",
                option = {
                    -- Use all visible buffers for suggestions
                    get_bufnrs = function()
                        local bufs = {}
                        for _, win in ipairs(vim.api.nvim_list_wins()) do
                            table.insert(bufs, vim.api.nvim_win_get_buf(win))
                        end
                        return bufs
                    end,
                },
            },
        },
    }
end

return M
