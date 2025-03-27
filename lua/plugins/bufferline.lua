require("bufferline").setup{}

local function has_nvim_tree_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "NvimTree" then
      return true
    end
  end
  return false
end

local function update_bufferline_offset()
  require("bufferline").setup({
    options = {
      offsets = has_nvim_tree_window() and {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          text_align = "left",
          highlight = "Directory",
        }
      } or {}
    }
  })
end

update_bufferline_offset()

vim.api.nvim_create_autocmd({ "WinEnter", "WinClosed", "BufEnter", "BufDelete" }, {
  callback = function(args)
    if args.filetype == "NvimTree" 
       or vim.fn.expand("<afile>") == "NvimTree"
       or vim.fn.expand("<afile>") == "NvimTree_" then
      vim.defer_fn(update_bufferline_offset, 50)
    end
  end
})
