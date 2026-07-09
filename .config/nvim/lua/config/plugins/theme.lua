require("tokyonight").setup({
    style = "night",

    on_colors = function(colors)
        colors.terminal_black = ""
    end,
})

vim.cmd.colorscheme("tokyonight")
