local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		border = false,
		mappings = {
			i = {
				["<esc>"] = actions.close,
			},

			n = {
				["<esc>"] = actions.close,
			},
		},

		layout_strategy = "horizontal",

		layout_config = {
			prompt_position = "top",
		},

		sorting_strategy = "ascending",
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

pcall(telescope.load_extension, "fzf")
