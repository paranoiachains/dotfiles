vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".git", "init.lua" },

	on_init = function(client)
		local folders = client.workspace_folders
		if folders then
			local path = folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
		})
	end,
	settings = { Lua = {} },
})

-- Now this will respect the filetypes and root_markers defined above
vim.lsp.enable("lua_ls")

vim.lsp.config("rust_analyzer", {
	cmd = { "rust-analyzer" }, -- or full path: "/home/you/.cargo/bin/rust-analyzer"
	filetypes = { "rust" },

	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
				loadOutDirsFromCheck = true,
			},
			assists = {
				importMergeBehavior = "last",
				importPrefix = "by_self",
			},
			checkOnSave = true,
			inlayHints = {
				lifetimeElisionHints = {
					enable = true,
					useParameterNames = true,
				},
				parameterHints = {
					enable = true,
				},
				chainingHints = {
					enable = true,
				},
			},
			diagnostics = {
				enable = true,
			},
		},
	},
})

vim.lsp.enable("rust_analyzer")

vim.lsp.config("taplo", {
	filetypes = { "toml" },
})
vim.lsp.enable("taplo")

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics under cursor" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "grn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })
vim.keymap.set("n", "grd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
vim.keymap.set("n", "<C-k>", function()
	vim.lsp.buf.signature_help()
end, opts)
vim.keymap.set("i", "<C-k>", function()
	vim.lsp.buf.signature_help()
end, opts)

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	callback = function(args)
		vim.lsp.start({
			name = "clangd",
			cmd = { "clangd" },
			root_dir = vim.fn.getcwd(), -- use current working dir as root
			filetypes = { "c", "cpp" },
		})
	end,
})

vim.lsp.config("pyright", {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	on_init = function(client)
		local folders = client.workspace_folders
		if folders then
			local path = folders[1].name
			-- ignore if a config file exists in workspace
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

local function load_schemastore()
	local schemas_path = os.getenv("HOME") .. "/.local/share/nvim/schemastore/schemas.json"
	local file = io.open(schemas_path, "r")

	if not file then
		vim.notify(
			"Schemastore not found. Run: curl -o ~/.local/share/nvim/schemastore/schemas.json https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/api/json/catalog.json"
		)
		return {}
	end

	local content = file:read("*a")
	file:close()

	local ok, schemas = pcall(vim.json.decode, content)
	if not ok then
		vim.notify("Failed to parse schemastore JSON")
		return {}
	end

	return schemas.schemas or {}
end

vim.lsp.config("jsonls", {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	settings = {
		json = {
			schemas = load_schemastore(),
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

vim.lsp.config("tsserver", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	on_init = function(client)
		local folders = client.workspace_folders
		if folders then
			local path = folders[1].name
			-- If a project-local config exists, respect it
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/tsconfig.json") or vim.uv.fs_stat(path .. "/jsconfig.json"))
			then
				return
			end
		end

		client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		})
	end,
	settings = {
		typescript = {},
		javascript = {},
	},
})

vim.lsp.enable("tsserver")
