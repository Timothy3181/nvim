require("noice").setup({
  messages = {
    enabled = true,
    view = "notify",
    view_error = "notify",
    view_warn = "notify",
  },
  cmdline = {
    enabled = true,
    view = "cmdline_popup",
    position = {
      row = 5,
      col = "50%",
    },
  },
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
  presets = {
    bottom_search = false,
    long_message_to_split = false,
  }
})
