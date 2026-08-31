vim.api.nvim_create_autocmd("InsertEnter", {
    once = true,
    callback = function()
        require("config.plugins.completion").setup()
    end
})

