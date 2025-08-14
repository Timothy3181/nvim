return {
    'HallerPatrick/py_lsp.nvim',
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
        local nvim_lsp = vim.lsp
        require'py_lsp'.setup {
            host_python = "/opt/homebrew/bin/python3.13",
            default_venv_name = ".venv" -- For local venv
        }
    end
}
