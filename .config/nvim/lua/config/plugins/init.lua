local gh = function(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({
	gh("saghen/blink.cmp"),
	gh("saghen/blink.lib"),

	gh("mason-org/mason.nvim"),
	gh("mason-org/mason-lspconfig.nvim"),

	gh("stevearc/conform.nvim"),

	gh("nvim-lualine/lualine.nvim"),

	gh("rebelot/kanagawa.nvim"),

	gh("akinsho/toggleterm.nvim"),

	gh("nvim-telescope/telescope.nvim"),
	gh("nvim-lua/plenary.nvim"),
	gh("nvim-telescope/telescope-fzf-native.nvim"),
	gh("nvim-telescope/telescope-file-browser.nvim"),

	gh("nvim-mini/mini.pairs"),
	gh("nvim-mini/mini.surround"),
})

require("config.plugins.mason")
require("config.plugins.format")
require("config.plugins.lualine")
require("config.plugins.completion")
require("config.plugins.theme")
require("config.plugins.terminal")
require("config.plugins.telescope")
require("config.plugins.mini")
