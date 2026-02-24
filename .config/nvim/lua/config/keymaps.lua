vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>q", "<cmd>bd<CR>", { desc = "Close current buffer" })

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "E", "^", opts)
vim.api.nvim_set_keymap("v", "E", "^", opts)

-- remove distraction
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

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics under cursor" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "grn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })
vim.keymap.set("n", "grd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
vim.keymap.set("n", "<C-k>", function()
	vim.lsp.buf.signature_help()
end, opts)
vim.keymap.set("i", "<C-k>", function()
	vim.lsp.buf.signature_help()
end, opts)

-- telescope keymaps
local telescope = require("telescope")
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>fd", builtin.find_files, { desc = "Find files (project)" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep (project)" })
vim.keymap.set("n", "<leader>fe", builtin.buffers, { desc = "Find buffers" })

vim.keymap.set("n", "<leader>fb", telescope.extensions.file_browser.file_browser, { desc = "File browser (cwd)" })

vim.keymap.set("n", "<leader>;", function()
	local line = vim.api.nvim_get_current_line()
	if not line:match(";%s*$") then
		vim.api.nvim_set_current_line(line .. ";")
	end
end, { desc = "Append semicolon to current line" })

vim.keymap.set("n", "<leader>fn", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Search Neovim files" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
