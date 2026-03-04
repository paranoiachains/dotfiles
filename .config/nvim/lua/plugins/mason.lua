return {
	-- Mason core
	{
		"mason-org/mason.nvim",
		opts = {
			ui = {
				border = "rounded",
			},
		},
	},

	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"basedpyright",
				"rust_analyzer",
				"ts_ls",
				"neocmake",
				"lua_ls",
			},
			automatic_installation = true,
			automatic_enable = true,
		},
	},
}
