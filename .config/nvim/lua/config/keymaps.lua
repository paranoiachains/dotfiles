-- general
vim.keymap.set("n", "<Tab>", vim.cmd.bnext)
vim.keymap.set("n", "<S-Tab>", vim.cmd.bprevious)
vim.keymap.set("n", "<leader>q", vim.cmd.bdelete)

vim.keymap.set("n", "m", ":m .+1<CR>==")
vim.keymap.set("n", "<C-m>", ":m .-2<CR>==")
vim.keymap.set("v", "m", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-m>", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>t", vim.cmd.tabnew)

vim.keymap.set({ "n", "v", "o" }, "$", "g_", { noremap = true })

local opts = { noremap = true, silent = true }

vim.keymap.set({ "n", "v", "i" }, "<Down>", "<Nop>", opts)
vim.keymap.set({ "n", "v", "i" }, "<Up>", "<Nop>", opts)
vim.keymap.set({ "n", "v", "i" }, "<Right>", "<Nop>", opts)
vim.keymap.set({ "n", "v", "i" }, "<Left>", "<Nop>", opts)

vim.keymap.set("n", "<Esc><Esc>", vim.cmd.nohlsearch, { silent = true })

-- stolen from lazy
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.hl_op()
	end,
})

-- lsp
vim.keymap.set("n", "grd", vim.lsp.buf.definition)

-- telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fd", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
vim.keymap.set("n", "<leader>fb", builtin.buffers)
vim.keymap.set("n", "<leader>fn", function()
	builtin.find_files({
		cwd = vim.fn.stdpath("config"),
	})
end)
