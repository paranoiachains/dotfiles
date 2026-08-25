-- general
vim.keymap.set("n", "<Tab>", vim.cmd.bnext, { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", vim.cmd.bprevious, { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>q", vim.cmd.bdelete, { desc = "Close current buffer" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "gx", function()
	local line = vim.api.nvim_get_current_line()
	local col = vim.fn.col(".")
	local url = line:match("%b[]%((.-)%)")
	if url then
		vim.ui.open(url)
	end
end)

vim.keymap.set("n", "<leader>t", vim.cmd.tabnew, { desc = "New tab" })

local opts = { noremap = true, silent = true }

vim.keymap.set({ "n", "v", "o" }, "$", "g_", { noremap = true })

vim.keymap.set("", "<Up>", "<Nop>", opts)
vim.keymap.set("", "<Down>", "<Nop>", opts)
vim.keymap.set("", "<Left>", "<Nop>", opts)
vim.keymap.set("", "<Right>", "<Nop>", opts)

vim.keymap.set("n", "<Esc><Esc>", vim.cmd.nohlsearch, { silent = true })

vim.keymap.set("n", "<leader>;", function()
	local line = vim.api.nvim_get_current_line()
	if not line:match(";%s*$") then
		vim.api.nvim_set_current_line(line .. ";")
	end
end, { desc = "Append semicolon to current line" })

-- stolen from lazy
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- lsp
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics under cursor" })
vim.keymap.set("n", "grn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })
vim.keymap.set("n", "grd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
vim.keymap.set("n", "gri", vim.lsp.buf.implementation, { desc = "[G]oto [I]mplementation" })
vim.keymap.set("n", "grr", vim.lsp.buf.references, { desc = "[G]oto [R]eferences" })
vim.keymap.set({ "n", "i" }, "<C-k>", function()
	vim.lsp.buf.signature_help({ border = "rounded" })
end, opts)

vim.keymap.set("n", "K", function()
	vim.lsp.buf.hover({
		border = "solid",
		max_width = 100,
		max_height = 25,
	})
end)

vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({
		count = -1,
	})
end, { desc = "Jump to previous diagnostic" })

vim.keymap.set("n", "d]", function()
	vim.diagnostic.jump({
		count = 1,
	})
end, { desc = "Jump to next diagnostic" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cpp", "c" },
	callback = function()
		vim.keymap.set("n", "<leader>k", function()
			local word = vim.fn.expand("<cword>")
			vim.cmd("!cppman " .. word)
		end, { buffer = true, desc = "cppman lookup" })
	end,
})

-- telescope
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>fd", builtin.find_files, { desc = "Find files (project)" })
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
vim.keymap.set("n", "<leader>fe", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fn", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Search Neovim files" })
