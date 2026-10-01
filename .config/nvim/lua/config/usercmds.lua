vim.api.nvim_create_user_command("PackClean", function(_)
	pcall(vim.cmd.packdel, "++all")
end, {})
