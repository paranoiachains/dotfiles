vim.cmd.syntax("off")

local function on_jump(diagnostic, bufnr)
    if not diagnostic then
        return
    end

    vim.diagnostic.show(
        diagnostic.namespace,
        bufnr,
        { diagnostic },
        { virtual_lines = { current_line = true }, virtual_text = false }
    )
end

vim.diagnostic.config({
    float = {
        border = "rounded",
    },

    jump = {
        on_jump = on_jump,
    },
})

vim.lsp.config("*", {
    root_markers = { ".git" }
})

vim.lsp.enable("c")
vim.lsp.enable("bash")
vim.lsp.enable("rust")
vim.lsp.enable("lua")
vim.lsp.enable("python")
