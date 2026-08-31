vim.api.nvim_create_user_command("PackClean", function(_)
	pcall(vim.cmd.packdel, "++all")
end, {})

vim.api.nvim_create_user_command("PackUpdate", function()
	local installed = vim.pack.get(nil, { offline = false })

	for _, plugin in ipairs(installed) do
		if plugin.rev ~= plugin.rev_to then
			vim.cmd.packupdate(plugin.spec.name)
		end
	end
end, {})
