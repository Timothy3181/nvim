local opt = { noremap = true, silent = true }

-- neovim
vim.keymap.set("n", "<C-s>", ":w<CR>", opt)
vim.keymap.set("n", "H", "5h", opt)
vim.keymap.set("n", "J", "5j", opt)
vim.keymap.set("n", "K", "5k", opt)
vim.keymap.set("n", "L", "5l", opt)

-- codecompanion
vim.keymap.set("n", "<leader>ac", ":CodeCompanionChat Toggle<CR>", opt)
-- vim.keymap.set("v", "<leader>ai", ":CodeCompanion ", opt)
