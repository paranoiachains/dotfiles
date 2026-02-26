vim.lsp.config("pyright", {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	on_init = function(client)
		local folders = client.workspace_folders
		if folders then
			local path = folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (
					vim.uv.fs_stat(path .. "/pyproject.toml")
					or vim.uv.fs_stat(path .. "/setup.py")
					or vim.uv.fs_stat(path .. "requirements.txt")
				)
			then
				return
			end
		end

		client.config.settings.python = vim.tbl_deep_extend("force", client.config.settings.python, {
			analysis = {
				typeCheckingMode = "basic",
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
			},
		})
	end,
	settings = {
		python = {},
	},
})

vim.lsp.enable("pyright")
