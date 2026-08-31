local M = {}

local initialized = false

function M.setup()
    if initialized then
        return
    end

    initialized = true

    local actions = require("telescope.actions")
    local telescope = require("telescope")

    telescope.setup({
	defaults = {
		border = true,
		mappings = {
			i = {
				["<esc>"] = actions.close,

				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,

				-- clear prompt on <C-u>
				["<C-u>"] = false,
			},
		},

		layout_strategy = "horizontal",

		layout_config = {
			prompt_position = "top",
			horizontal = {
				preview_width = 0.55,
				width = 0.95,
				height = 0.90,
			},
			vertical = {
				width = 0.95,
				height = 0.95,
			},
		},

		path_display = {
			"truncate",
		},

		dynamic_preview_title = true,

		sorting_strategy = "ascending",

		file_ignore_patterns = {
			"%.git/",
			"node_modules/",
			"target/",
			"dist/",
			"build/",
			"__pycache__/",
			"%.o",
			"%.a",
			"%.so",
			"%.class",
		},
	},

	pickers = {
		find_files = {
			find_command = {
				"fd",
				"--type",
				"f",
				"--strip-cwd-prefix",
				"--hidden",
				"--follow",
				"--exclude",
				".git",
			},
		},

		live_grep = {
			only_sort_text = true,
		},

		buffers = {
			sort_mru = true,
			ignore_current_buffer = true,
			previewer = false,
		},

		help_tags = {
			previewer = false,
		},

		colorscheme = {
			enable_preview = true,
		},
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
end

function M.builtin()
    M.setup()
    return require("telescope.builtin")
end

return M
