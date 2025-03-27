local nvim_tree_api = require("nvim-tree.api")

local function update_ui()
  local is_tree_open = nvim_tree_api.tree.is_visible()
  require("bufferline").setup({
    options = {
      offsets = is_tree_open and {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          text_align = "center",
          highlight = "Directory",
        }
      } or {}
    }
  })
  require('lualine').setup({
    options = {
      ignore_focus = is_tree_open and {'NvimTree'} or {}
    }
  })
end
update_ui()
nvim_tree_api.events.subscribe("TreeOpen", update_ui)
nvim_tree_api.events.subscribe("TreeClose", update_ui)

vim.api.nvim_create_autocmd({ "WinEnter", "WinClosed" }, {
  callback = function()
    vim.defer_fn(update_ui, 50)
  end
})
