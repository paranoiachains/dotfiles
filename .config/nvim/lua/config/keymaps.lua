-- general
vim.keymap.set("n", "<Tab>", vim.cmd.bnext)
vim.keymap.set("n", "<S-Tab>", vim.cmd.bprevious)
vim.keymap.set("n", "<leader>q", vim.cmd.bdelete)

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<leader>t", vim.cmd.tabnew)

local opts = { noremap = true, silent = true }

vim.keymap.set({ "n", "v", "o" }, "$", "g_", { noremap = true })

vim.keymap.set({"n", "v", "i"}, "<Up>", "<Nop>", opts)
vim.keymap.set({"n", "v", "i"}, "<Down>", "<Nop>", opts)
vim.keymap.set({"n", "v", "i"}, "<Left>", "<Nop>", opts)
vim.keymap.set({"n", "v", "i"}, "<Right>", "<Nop>", opts)

vim.keymap.set("n", "<Esc><Esc>", vim.cmd.nohlsearch, { silent = true })

-- stolen from lazy
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.hl_op()
    end
})

-- lsp
vim.keymap.set("n", "grd", vim.lsp.buf.definition)

-- telescope
local telescope = require("config.plugins.telescope")

vim.keymap.set("n", "<leader>fd", function()
    telescope.builtin().find_files()
end)

vim.keymap.set("n", "<leader>fg", function()
    telescope.builtin().live_grep({
        additional_args = function(_)
            return {
                "--hidden",
                "--glob",
                "!.git/*",
            }
        end,
    })
end)

vim.keymap.set("n", "<leader>fe", function()
    telescope.builtin().buffers()
end)

vim.keymap.set("n", "<leader>fn", function()
    telescope.builtin().find_files({
        cwd = vim.fn.stdpath("config"),
    })
end)
