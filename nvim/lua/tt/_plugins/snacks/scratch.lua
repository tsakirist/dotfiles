local M = {}

---@type snacks.scratch.Config|{}
M.scratch = {
    template = "",
    win_by_ft = {
        lua = {
            keys = {
                ["source"] = {
                    "<C-s>",
                    mode = { "n", "x" },
                    function(self)
                        local name = "scratch." .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
                        Snacks.debug.run { buf = self.buf, name = name }
                    end,
                    desc = "Execute buffer",
                },
            },
        },
    },
}

return M
