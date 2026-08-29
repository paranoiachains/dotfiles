vim.cmd.syntax("off")

local function on_jump(diagnostic, bufnr)
    if not diagnostic then
        return
    end

    vim.diagnostic.show(
        diagnostic.namespace,
        bufnr,
        { diagnostic },
        {}
    )
end

vim.diagnostic.config({
    jump = {
        on_jump = on_jump,
    },

    virtual_lines = { current_line = true },
    virtual_text = false
})

vim.lsp.enable("c")
vim.lsp.enable("bash")
vim.lsp.enable("rust")
vim.lsp.enable("lua")
vim.lsp.enable("python")
