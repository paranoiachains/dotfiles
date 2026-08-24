local ts = require("nvim-treesitter")

ts.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

ts.install({
	"rust",
	"lua",
	"vim",
	"vimdoc",
	"markdown",
	"markdown_inline",
	"query",
	"toml",
	"yaml",
	"json",
})

vim.filetype.add({
	pattern = {
		["${XDG_CONFIG_HOME}/zsh/.*"] = "zsh",
	},
})

local group = vim.api.nvim_create_augroup("treesitter", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf)
	end,
})
