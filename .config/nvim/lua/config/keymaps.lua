-- general
vim.keymap.set("n", "<Tab>", vim.cmd.bnext)
vim.keymap.set("n", "<S-Tab>", vim.cmd.bprevious)
vim.keymap.set("n", "<leader>q", vim.cmd.bdelete)

vim.keymap.set("n", "<leader>tn", vim.cmd.tabnew)
vim.keymap.set("n", "<leader>tc", vim.cmd.close)

vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-w>h", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-w>j", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-w>k", "<C-\\><C-n><C-w>k")
vim.keymap.set("t", "<C-w>l", "<C-\\><C-n><C-w>l")

vim.keymap.set({ "n", "v", "o" }, "$", "g_", { noremap = true })

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
local function telescope_picker(name, opts)
	return function()
		require("config.plugins.telescope").setup()
		require("telescope.builtin")[name](opts)
	end
end

vim.keymap.set("n", "<leader>fd", telescope_picker("find_files"))
vim.keymap.set("n", "<leader>fg", telescope_picker("live_grep"))
vim.keymap.set("n", "<leader>fb", telescope_picker("buffers"))

vim.keymap.set("n", "<leader>fn", function()
	require("config.plugins.telescope").setup()
	require("telescope.builtin").find_files({
		cwd = vim.fn.stdpath("config"),
	})
end)

-- terminal
vim.keymap.set("n", "<C-t>", function()
	local buf = vim.api.nvim_create_buf(false, true)

	local win = vim.api.nvim_open_win(buf, true, {
		split = "left",
		win = 0,
	})

	vim.fn.jobstart(vim.o.shell, {
		term = true,
		on_exit = function()
			if vim.api.nvim_buf_is_valid(buf) then
				vim.schedule(function()
					vim.api.nvim_buf_delete(buf, { force = true })
				end)
			end
		end,
	})

	vim.bo[buf].buflisted = false
	vim.cmd.startinsert()
end, { desc = "Open terminal" })
