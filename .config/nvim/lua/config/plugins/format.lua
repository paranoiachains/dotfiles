require("conform").setup({
	formatters = {
		["clang-format"] = {
			append_args = {
				"--style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Never}",
			},
		},

		["shfmt"] = {
			append_args = function(_, ctx)
				if ctx.ft == "bash" then
					return { "-ln", "bash" }
				elseif ctx.ft == "zsh" then
					return { "-ln", "zsh" }
				end

				return {}
			end,
		},
	},

	format_on_save = {
		lsp_format = "fallback",
	},

	default_format_opts = {
		lsp_format = "fallback",
	},

	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		python = { "ruff" },
		bash = { "shfmt" },
		sh = { "shfmt" },
		zsh = { "shfmt" },
		json = { "prettier" },
		jsonc = { "prettier" },
		["_"] = { "trim_whitespace" },
	},
})
