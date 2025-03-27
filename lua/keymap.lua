-- leader setting
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keyset = vim.keymap.set

-- nvim
keyset("n", "<leader>s", "<cmd>w<CR>", { silent = true, noremap = true })

-- lazy
keyset("n", "<leader>ll", "<cmd>Lazy<CR>", { silent = true, noremap = true })

-- mason
keyset("n", "<leader>mm", "<cmd>Mason<CR>", { silent = true, noremap = true })

-- nvim-tree
keyset("n", "<leader>w", "<cmd>NvimTreeToggle<CR>", { silent = true, noremap = true })
keyset("n", "<leader>q", "<cmd>wincmd p<CR>", { silent = true, noremap = true })

-- nvim-cmp
keyset("n", "<leader>ms", "<cmd>lua vim.lsp.buf.hover()<CR>", { silent = true, noremap = true })

-- toggleterm
keyset("n", "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", { silent = true, noremap = true })

-- bufferline
keyset("n", "<leader>x", "<cmd>BufferLineCycleNext<CR>", { silent = true, noremap = true })
keyset("n", "<leader>z", "<cmd>BufferLineCyclePrev<CR>", { silent = true, noremap = true })
keyset("n", "<leader>bc", "<cmd>bdelete<CR>", { silent = true, noremap = true })
keyset("n", "<leader>bz", "<cmd>BufferLineMovePrev<CR>", { silent = true, noremap = true })
keyset("n", "<leader>bx", "<cmd>BufferLineMoveNext<CR>", { silent = true, noremap = true })
keyset("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", { silent = true, noremap = true })

-- cmake
keyset("n", "<leader>cg", "<cmd>CMakeGenerate<CR>", { silent = true, noremap = true })
keyset("n", "<leader>cb", "<cmd>CMakeBuild<CR>", { silent = true, noremap = true })
keyset("n", "<leader>cr", "<cmd>CMakeRun<CR>", { silent = true, noremap = true })
keyset("n", "<leader>ct", "<cmd>CMakeRunTest<CR>", { silent = true, noremap = true })
