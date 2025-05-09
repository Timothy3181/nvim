require('mason').setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require('mason-lspconfig').setup({
    ensure_installed = { 'pyright', 'lua_ls', 'rust_analyzer', 'clangd', 'cmake', 'yamlls', 'html' },
})
