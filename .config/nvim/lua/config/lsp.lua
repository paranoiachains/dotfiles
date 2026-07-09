vim.lsp.buf.signature_help({ border = "rounded" })

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

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--completion-style=detailed",
		"--header-insertion=iwyu",
		"--function-arg-placeholders=true",
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
