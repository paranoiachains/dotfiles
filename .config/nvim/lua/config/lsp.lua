vim.keymap.set("n", "K", function()
	vim.lsp.buf.hover({
		border = "rounded",
	})
end)

vim.keymap.set("i", "<C-k>", function()
	vim.lsp.buf.signature_help({
		border = "rounded",
	})
end)

vim.diagnostic.config({
	float = {
		border = "rounded",
	},
	jump = {
		float = true,
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

vim.lsp.config("roslyn", {
	cmd = { "roslyn-language-server", "--stdio" },

	filetypes = { "cs" },

	root_markers = {
		"*.sln",
		"*.csproj",
		".git",
	},

	settings = {
		["csharp|inlay_hints"] = {
			csharp_enable_inlay_hints_for_implicit_object_creation = true,
			csharp_enable_inlay_hints_for_implicit_variable_types = true,
			csharp_enable_inlay_hints_for_lambda_parameter_types = true,
			csharp_enable_inlay_hints_for_types = true,
			dotnet_enable_inlay_hints_for_indexer_parameters = true,
			dotnet_enable_inlay_hints_for_literal_parameters = true,
			dotnet_enable_inlay_hints_for_object_creation_parameters = true,
			dotnet_enable_inlay_hints_for_other_parameters = true,
			dotnet_enable_inlay_hints_for_parameters = true,
			dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
			dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
			dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
		},
	},
})

vim.lsp.enable("roslyn")

vim.lsp.config("jdtls", {
	cmd = { "jdtls" },

	filetypes = { "java" },

	root_markers = {
		".git",
		"mvnw",
		"gradlew",
		"pom.xml",
		"build.gradle",
		"build.gradle.kts",
	},
})

vim.lsp.enable("jdtls")
