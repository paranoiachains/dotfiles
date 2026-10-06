vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		require("config.plugins.completion").setup()
	end,
})

local aug = vim.api.nvim_create_augroup("UserTerminal", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
	group = aug,
	callback = function()
		vim.cmd("startinsert")
	end,
})
