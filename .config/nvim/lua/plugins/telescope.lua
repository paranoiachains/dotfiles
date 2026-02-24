return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-file-browser.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<esc>"] = actions.close,
						},
						n = {
							["<esc>"] = actions.close,
						},
					},
					layout_strategy = "horizontal",
					layout_config = { prompt_position = "top" },
					sorting_strategy = "ascending",
					winblend = 0,
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
					file_browser = {
						hijack_netrw = true,
					},
				},
			})

			telescope.load_extension("fzf")
			telescope.load_extension("file_browser")

			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<leader>fd", builtin.find_files, { desc = "Find files (project)" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep (project)" })
			vim.keymap.set("n", "<leader>fe", builtin.buffers, { desc = "Find buffers" })

			vim.keymap.set(
				"n",
				"<leader>fb",
				telescope.extensions.file_browser.file_browser,
				{ desc = "File browser (cwd)" }
			)

			vim.keymap.set("n", "<leader>;", function()
				local line = vim.api.nvim_get_current_line()
				if not line:match(";%s*$") then
					vim.api.nvim_set_current_line(line .. ";")
				end
			end, { desc = "Append semicolon to current line" })

			vim.keymap.set("n", "<leader>fn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "Search Neovim files" })

			vim.keymap.set("n", "<leader>ff", function()
				builtin.find_files({ cwd = vim.fn.expand("%:p:h") })
			end, { desc = "Find files (current dir)" })
		end,
	},
}
