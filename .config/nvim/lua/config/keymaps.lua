vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>q", "<cmd>bd<CR>", { desc = "Close current buffer" })
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "E", "^", opts)
vim.api.nvim_set_keymap("v", "E", "^", opts)
vim.keymap.set("", "<Up>", "<Nop>", opts)
vim.keymap.set("", "<Down>", "<Nop>", opts)
vim.keymap.set("", "<Left>", "<Nop>", opts)
vim.keymap.set("", "<Right>", "<Nop>", opts)
vim.keymap.set("n", "<Esc><Esc>", "<cmd>nohlsearch<CR>", { silent = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		require("lazy").update({ show = false })
	end,
})
