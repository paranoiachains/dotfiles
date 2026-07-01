local M = {}

---Install missing tresitter parsers
---@param parsers string[]
function M.setup(parsers)
	for _, parser in ipairs(parsers) do
		if not pcall(vim.treesitter.language.add, parser) then
			vim.notify("Parser " .. parser .. "not found", vim.log.levels.WARN)
		end
	end
end

return M
