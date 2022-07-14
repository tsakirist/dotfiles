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
    winhighlight = "Normal:NormalFloat,FloatBorder:CmpWindowBorder,CursorLine:Visual,Search:None",
}

local cmp = require "cmp"
local luasnip = require "luasnip"
local neogen = require "neogen"

-- Functions for mapping <Tab> and <S-Tab> for nvim-cmp
local function tab(fallback)
    local has_words_before = function()
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
        completion = {
            -- The minimum length of a word to complete on
            keyword_length = 1,
        },
        experimental = {
            ghost_text = true,
            native_menu = false,
        },
        formatting = {
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
                vim_item.dup = 0

                return vim_item
            end,
        },
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
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
            ["<C-e>"] = cmp.mapping.scroll_docs(4),
            ["<C-y>"] = cmp.mapping.scroll_docs(-4),
            ["<C-Space>"] = cmp.mapping.complete(),
        },
        sources = {
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "luasnip" },
            { name = "path" },
            {
                name = "buffer",
                keyword_length = 3,
                options = {
                    -- Get results only from visible buffers rather than from all buffers
                    get_bufnrs = function()
                        local bufs = {}
                        for _, win in ipairs(vim.api.nvim_list_wins()) do
                            bufs[vim.api.nvim_win_get_buf(win)] = true
                        end
                        return vim.tbl_keys(bufs)
                    end,
                },
            },
        },
    }
end

return M
