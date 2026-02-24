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

vim.lsp.enable("lua_ls")

vim.lsp.config("rust_analyzer", {
	cmd = { "rust-analyzer" },
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

local function switch_source_header(bufnr, client)
	local method = "textDocument/switchSourceHeader"
	if not client or not client:supports_method(method) then
		return vim.notify(method .. " not supported by clangd")
	end

	local params = vim.lsp.util.make_text_document_params(bufnr)
	client:request(method, params, function(err, result)
		if err then
			return vim.notify(tostring(err), vim.log.levels.ERROR)
		end
		if not result then
			return vim.notify("Corresponding file not found")
		end
		vim.cmd.edit(vim.uri_to_fname(result))
	end, bufnr)
end

local function symbol_info(bufnr, client)
	local method = "textDocument/symbolInfo"
	if not client or not client:supports_method(method) then
		return vim.notify("Clangd client not found", vim.log.levels.ERROR)
	end

	local win = vim.api.nvim_get_current_win()
	local params = vim.lsp.util.make_position_params(win, client.offset_encoding)

	client:request(method, params, function(_, res)
		if not res or #res == 0 then
			return
		end

		local name = ("name: %s"):format(res[1].name)
		local container = ("container: %s"):format(res[1].containerName)

		vim.lsp.util.open_floating_preview({ name, container }, "", {
			title = "Symbol Info",
			focusable = false,
		})
	end, bufnr)
end

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--completion-style=detailed",
		"--header-insertion=iwyu",
		"--function-arg-placeholders",
	},

	filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },

	root_markers = {
		".clangd",
		".clang-tidy",
		".clang-format",
		"compile_commands.json",
		"compile_flags.txt",
		"CMakeLists.txt",
		"meson.build",
		"configure.ac",
		".git",
	},

	capabilities = {
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
		offsetEncoding = { "utf-8", "utf-16" },
	},

	on_init = function(client, init_result)
		if init_result and init_result.offsetEncoding then
			client.offset_encoding = init_result.offsetEncoding
		end

		local folders = client.workspace_folders
		if not folders then
			return
		end

		local path = folders[1].name
		if vim.uv.fs_stat(path .. "/compile_commands.json") or vim.uv.fs_stat(path .. "/compile_flags.txt") then
			return
		end

		client.config.settings = vim.tbl_deep_extend("force", client.config.settings or {}, {
			clangd = {
				fallbackFlags = {
					"-std=c++20",
					"-Wall",
					"-Wextra",
				},
			},
		})
	end,

	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspClangdSwitchSourceHeader", function()
			switch_source_header(bufnr, client)
		end, { desc = "Switch between source/header" })

		vim.api.nvim_buf_create_user_command(bufnr, "LspClangdShowSymbolInfo", function()
			symbol_info(bufnr, client)
		end, { desc = "Show clangd symbol info" })
	end,

	settings = {
		clangd = {},
	},
})

vim.lsp.enable("clangd")

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
