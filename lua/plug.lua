-- github theme
vim.pack.add({
    { src = "https://github.com/projekt0n/github-nvim-theme" },
})
vim.cmd('colorscheme github_dark_tritanopia')

-- treesitter
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

require("nvim-treesitter").setup({
    install_dir = vim.fn.stdpath("data") .. ""
})
require("nvim-treesitter").install { 'c', 'cpp', 'python', 'lua' }

---- lsp config
vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
})
-- python
vim.lsp.config('pyright', {
    settings = { python = { analysis = { typeCheckingMode = "strict" } } }
})
vim.lsp.enable('pyright')
-- c & cpp
vim.lsp.config('clangd', {
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
})
vim.lsp.enable('clangd')
-- rust analyzer
vim.lsp.config('rust_analyzer', {
    filetypes = { 'rust' },
})
vim.lsp.enable('rust_analyzer')
-- lua lsp
vim.lsp.config('lua_ls', {
    filetypes = { 'lua' },
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})
vim.lsp.enable('lua_ls')
-- diagnostics setting
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
})

-- lualine
vim.pack.add({
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/nvim-lualine/lualine.nvim'
})

require('lualine').setup({
    options = {
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        globalstatus = true,
    },
})

-- nvim tree
vim.pack.add({
    { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
})

require('nvim-tree').setup({})
