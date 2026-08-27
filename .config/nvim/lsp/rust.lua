return {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "Cargo.lock" },

    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
            },
            assists = {
                importMergeBehavior = "last",
                importPrefix = "by_self",
            },
            checkOnSave = true,
            inlayHints = {
                lifetimeElisionHints = {
                    enable = true,
                    useParameterNames = true,
                },
                parameterHints = {
                    enable = true,
                },
                chainingHints = {
                    enable = true,
                },
            },
            diagnostics = {
                enable = true,
            },
        },
    },
}
