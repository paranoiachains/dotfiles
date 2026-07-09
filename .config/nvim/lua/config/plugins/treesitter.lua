local ts = require("nvim-treesitter")

ts.setup({
    install_dir = vim.fn.stdpath('data') .. '/site'
})

ts.install { 'rust', 'markdown', 'markdown_inline' }
