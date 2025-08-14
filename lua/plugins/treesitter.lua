return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate",
    opts = {
        auto_install = true,
        sync_install = false,
        ensure_installed = { "c", "lua", "vim", "rust", "cpp", "markdown", "markdown_inline" },
        highlight = {
            enable = true,
        },
    },
}
