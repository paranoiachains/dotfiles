local gh = function(repo)
    return "https://github.com/" .. repo
end

vim.pack.add({
    gh("saghen/blink.cmp"),
    gh("saghen/blink.lib"),

    gh("stevearc/conform.nvim"),

    gh("folke/tokyonight.nvim"),
    gh("nvim-treesitter/nvim-treesitter"),

    gh("nvim-telescope/telescope.nvim"),
    gh("nvim-lua/plenary.nvim"),
    gh("nvim-telescope/telescope-fzf-native.nvim"),
    gh("nvim-telescope/telescope-file-browser.nvim"),

    gh("nvim-mini/mini.pairs"),
    gh("nvim-mini/mini.surround"),
})


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

require("config.plugins.format")
require("config.plugins.completion")
require("config.plugins.theme")
require("config.plugins.telescope")
require("config.plugins.mini")
require("config.plugins.treesitter")
