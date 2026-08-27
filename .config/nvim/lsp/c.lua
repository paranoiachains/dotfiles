return {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--function-arg-placeholders=true",
    },

    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },

    root_markers = {
        { ".clangd",
            ".clang-tidy",
            ".clang-format",
            "compile_commands.json",
            "compile_flags.txt",
            "CMakeLists.txt",
            "meson.build", },
        "configure.ac",
    },

    capabilities = {
        textDocument = {
            completion = {
                editsNearCursor = true,
            },
        },
        offsetEncoding = { "utf-8", "utf-16" },
    },

    on_init = function(client, init_result)
        if init_result and init_result.offsetEncoding then
            client.offset_encoding = init_result.offsetEncoding
        end

        local folders = client.workspace_folders
        if not folders then
            return
        end

        local path = folders[1].name
        if vim.uv.fs_stat(path .. "/compile_commands.json") or vim.uv.fs_stat(path .. "/compile_flags.txt") then
            return
        end

        client.config.settings = vim.tbl_deep_extend("force", client.config.settings or {}, {
            clangd = {
                fallbackFlags = {
                    "-std=c++20",
                    "-Wall",
                    "-Wextra",
                },
            },
        })
    end,

    settings = {
        clangd = {},
    },
}
