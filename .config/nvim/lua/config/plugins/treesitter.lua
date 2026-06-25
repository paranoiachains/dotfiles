require("nvim-treesitter.config").setup({
	ensure_installed = {
		"lua",
		"vim",
		"vimdoc",
		"rust",
		"go",
		"c",
		"cpp",
		"python",
		"typescript",
	},

	highlight = {
		enable = true,
	},

	indent = {
		enable = true,
	},
})
