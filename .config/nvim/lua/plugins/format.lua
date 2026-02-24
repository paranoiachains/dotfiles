return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters = {
				["clang-format"] = {
					append_args = {
						"--style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Never}",
					},
				},
			},
			notify_on_error = false,
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "gofmt", "golangci-lint" },
				rust = { "clippy" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				toml = { "taplo" },
			},
		},
	},
}
