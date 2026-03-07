vim.lsp.config("neocmake", {
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

vim.lsp.config("basedpyright", {
	cmd = { "basedpyright-langserver", "--stdio" },
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

vim.lsp.config("ts_ls", {
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

local function switch_source_header()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	local clangd = nil

	for _, client in ipairs(clients) do
		if client.name == "clangd" then
			clangd = client
			break
		end
	end

	if not clangd then
		return vim.notify("Clangd client not attached", vim.log.levels.WARN)
	end

	local method = "textDocument/switchSourceHeader"
	if not clangd.supports_method(method) then
		return vim.notify(method .. " not supported by clangd")
	end

	local params = vim.lsp.util.make_text_document_params(bufnr)
	clangd.request(method, params, function(err, result)
		if err then
			return vim.notify(tostring(err), vim.log.levels.ERROR)
		end
		if not result then
			return vim.notify("Corresponding file not found")
		end
		vim.cmd.edit(vim.uri_to_fname(result))
	end, bufnr)
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client.name == "clangd" then
			local bufnr = args.buf
			vim.keymap.set("n", "gs", switch_source_header, {
				buffer = bufnr,
				desc = "Switch between source/header",
			})
		end
	end,
})

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

	settings = {
		clangd = {},
	},
})
vim.lsp.enable("clangd")
vim.lsp.config("intelephense", {
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php" },
})

vim.lsp.enable("intelephense")
