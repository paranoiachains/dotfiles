return {
	cmd = { "tsc", "--lsp", "-stdio" },
	filetypes = {
		"typescript",
		"typescriptreact",
		"javascript",
		"javascriptreact",
	},
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json" },
}
