return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function ()
        local keyset = vim.keymap.set
        require("bufferline").setup{}
        keyset("n", "<leader>x", "<cmd>BufferLineCycleNext<CR>", { silent = true, noremap = true })
        keyset("n", "<leader>z", "<cmd>BufferLineCyclePrev<CR>", { silent = true, noremap = true })
        keyset("n", "<leader>bc", "<cmd>bdelete<CR>", { silent = true, noremap = true })
        keyset("n", "<leader>bz", "<cmd>BufferLineMovePrev<CR>", { silent = true, noremap = true })
        keyset("n", "<leader>bx", "<cmd>BufferLineMoveNext<CR>", { silent = true, noremap = true })
        keyset("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", { silent = true, noremap = true })
    end
}
