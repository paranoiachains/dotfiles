require("mason").setup({
    ui = {
        border = "rounded",
    },
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "basedpyright",
        "rust_analyzer",
        "lua_ls",
    },

    automatic_enable = true,
})
