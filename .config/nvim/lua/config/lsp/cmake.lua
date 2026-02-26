vim.lsp.config("cmake", {
	cmd = { "neocmakelsp", "stdio" },
	filetypes = { "cmake" },
	root_markers = { "CMakePresets.json", "CTestConfig.cmake", ".git", "build", "cmake" },
	init_options = {
		format = {
			enable = true,
		},
		lint = {
			enable = true,
		},
	},
})

vim.lsp.enable("cmake")
