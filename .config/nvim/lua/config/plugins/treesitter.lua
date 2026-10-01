vim.filetype.add({
	pattern = {
		["${XDG_CONFIG_HOME}/zsh/.*"] = "zsh",
	},
})

local group = vim.api.nvim_create_augroup("treesitter", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,

	callback = function(ev)
		local ok = pcall(vim.treesitter.start, ev.buf)
		if not ok then
			vim.cmd.syntax("on")
		end
	end,
})
