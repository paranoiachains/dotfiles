require("nvim-treesitter").setup({})

---install missing tresitter parsers
---@param parsers string[]
local function install_parsers(parsers)
	for _, parser in ipairs(parsers) do
		if not pcall(vim.treesitter.language.add, parser) then
			vim.notify("Parser " .. parser .. "not found, installing...", vim.log.levels.WARN)
			vim.cmd.TSInstallSync(parser)
		end
	end
end

install_parsers({
	"rust",
	"python",
})
