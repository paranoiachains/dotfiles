-- general
vim.keymap.set("n", "<Tab>", vim.cmd.bnext)
vim.keymap.set("n", "<S-Tab>", vim.cmd.bprevious)
vim.keymap.set("n", "<leader>q", vim.cmd.bdelete)

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<leader>t", vim.cmd.tabnew)

local opts = { noremap = true, silent = true }

vim.keymap.set({ "n", "v", "o" }, "$", "g_", { noremap = true })

vim.keymap.set("", "<Up>", "<Nop>", opts)
vim.keymap.set("", "<Down>", "<Nop>", opts)
vim.keymap.set("", "<Left>", "<Nop>", opts)
vim.keymap.set("", "<Right>", "<Nop>", opts)

vim.keymap.set("n", "<Esc><Esc>", vim.cmd.nohlsearch, { silent = true })

-- stolen from lazy
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.hl_op()
    end
})

-- telescope
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>fd", builtin.find_files)
vim.keymap.set("n", "<leader>fg", function()
    builtin.live_grep({
        additional_args = function(_)
            return {
                "--hidden",
                "--glob",
                "!.git/*",
            }
        end,
    })
end, { desc = "Live grep (project)" })

vim.keymap.set("n", "<leader>fe", builtin.buffers)

vim.keymap.set("n", "<leader>fn", function()
    builtin.find_files({ cwd = vim.fn.stdpath("config") })
end)
