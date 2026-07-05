-- leader key
vim.g.mapleader = " "

-- common choice
local opts = { noremap = true, silent = true }

-- editer key
vim.keymap.set('n', 'H', '5h', opts)
vim.keymap.set('n', 'J', '5j', opts)
vim.keymap.set('n', 'K', '5k', opts)
vim.keymap.set('n', 'L', '5l', opts)

vim.keymap.set('n', '<leader>h', '<C-w>h', opts)
vim.keymap.set('n', '<leader>j', '<C-w>j', opts)
vim.keymap.set('n', '<leader>k', '<C-w>k', opts)
vim.keymap.set('n', '<leader>l', '<C-w>l', opts)

vim.keymap.set('n', '<C-s>', ':w<CR>', opts)

-- plugin key
vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>', opts)
