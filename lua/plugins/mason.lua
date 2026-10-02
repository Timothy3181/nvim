return {
    "mason-org/mason.nvim",
    opts = {
        -- Make Mason-installed executables (including tree-sitter) visible to
        -- Neovim and its child processes on every startup.
        PATH = "prepend",
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    }
}
