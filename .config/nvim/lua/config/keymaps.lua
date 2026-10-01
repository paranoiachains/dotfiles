-- general
vim.keymap.set("n", "<Tab>", vim.cmd.bnext)
vim.keymap.set("n", "<S-Tab>", vim.cmd.bprevious)
vim.keymap.set("n", "<leader>q", vim.cmd.bdelete)

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
