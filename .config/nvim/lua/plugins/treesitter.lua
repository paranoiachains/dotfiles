return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		tag = "v0.10.0",
		build = ":TSUpdate",
		event = "BufReadPost",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"rust",
					"go",
					"cpp",
					"bash",
					"json",
					"html",
					"c",
					"markdown",
					"javascript",
					"python",
				},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<CR>",
						node_incremental = "<CR>",
						scope_incremental = "<S-CR>",
						node_decremental = "<BS>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["ab"] = "@block.outer",
							["ib"] = "@block.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},
}
