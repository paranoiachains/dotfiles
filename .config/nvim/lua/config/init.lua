require("config.plugins")
require("config.settings")
require("config.keymaps")
require("config.lsp")

---install missing tresitter parsers
---@param parsers string[]
local function install_parsers(parsers)
	for _, parser in ipairs(parsers) do
		if not pcall(vim.treesitter.language.add, parser) then
			vim.notify("Parser " .. parser .. "not found", vim.log.levels.ERROR)
		end
	end
end

install_parsers({
	"rust",
	"python",
})
