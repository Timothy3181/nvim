-- neovim requirment
require("options")
require("keymap")

-- lazy
require("config.lazy")

-- theme
require("theme")

-- lsp
require("config.lsp")

-- cmp
require("config.cmp")

-- plugins
require("plugins.lualine")
require("plugins.treesitter")
require("plugins.telescope")
require("plugins.nvim-tree")
require("plugins.toggleterm")
require("plugins.bufferline")
require("plugins.cmake-tools")
require("plugins.lsp-signature")

-- after launch settings
require("config.bufferline-reset")
