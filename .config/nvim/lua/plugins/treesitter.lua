return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "BufReadPost",
		config = function()
			require("nvim-treesitter.config").setup({
				ensure_installed = {
					"lua",
					"rust",
					"go",
					"cpp",
					"bash",
					"json",
					"html",
					"c",
					"markdown",
					"js",
					"python",
				},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				incremental_selection = {
					enable = true,
				},
			})
		end,
	},
}
