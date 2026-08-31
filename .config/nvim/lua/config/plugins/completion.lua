local M = {}


function M.setup()
    local blink = require("blink.cmp")

    blink.setup({
        keymap = {
            preset = "none",

            ["<Tab>"] = { "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },

            ["<CR>"] = { "accept", "fallback" },

            ["<C-n>"] = { "scroll_documentation_down", "fallback" },
            ["<C-p>"] = { "scroll_documentation_up", "fallback" },
        },

        completion = {
            menu = {
                draw = {
                    columns = {
                        { "label", "label_description", gap = 1 },
                        { "kind" },
                    },
                },
            },

            documentation = {
                auto_show = true,
                auto_show_delay_ms = 0,
            },

            list = {
                selection = {
                    preselect = false,
                },
            },
        },

        sources = {
            default = {
                "lsp",
                "path",
                "buffer",
            },
        },

        fuzzy = {
            implementation = "lua",
        },
    })

    blink.build():wait()
end

return M

