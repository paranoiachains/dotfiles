vim.lsp.config("jsonls", {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	settings = {
		json = {
			validate = { enable = true },
			format = { enable = true },
		},
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				if vim.bo.filetype == "json" or vim.bo.filetype == "jsonc" then
					vim.lsp.buf.format({ async = false })
				end
			end,
		})
	end,
})
vim.lsp.enable("jsonls")

