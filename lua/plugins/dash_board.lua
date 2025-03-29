return function()
  local alpha = require("alpha")
  local dashboard = require("alpha.themes.dashboard")

  -- 设置 Logo
  local logo = [[
  ██╗   ██╗███████╗ ██████╗ ██████╗ ██████╗ ███████╗
  ██║   ██║██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔════╝
  ██║   ██║███████╗██║     ██║   ██║██║  ██║█████╗  
  ╚██╗ ██╔╝╚════██║██║     ██║   ██║██║  ██║██╔══╝  
   ╚████╔╝ ███████║╚██████╗╚██████╔╝██████╔╝███████╗
    ╚═══╝  ╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝
  ]]

  dashboard.section.header.val = vim.split(logo, "\n")

  -- 设置按钮（已翻译为中文）
  dashboard.section.buttons.val = {
    dashboard.button("f", " " .. " File Finder", ":Telescope find_files <CR>"),
    dashboard.button("n", " " .. " New File", ":ene <BAR> startinsert <CR>"),
    dashboard.button("g", " " .. " Text Finder", ":Telescope live_grep <CR>"),
    dashboard.button("t", " " .. " Terminal", ":ToggleTerm direction=horizontal <CR>"),
    dashboard.button("m", "󰬔 " .. " Mason", ":Mason <CR>"),
    dashboard.button("l", " " .. " Lazy", ":Lazy <CR>"),
    dashboard.button("e", "󰩈 " .. " Exit", ":qa <CR>"),
  }

  -- 高亮设置
  for _, button in ipairs(dashboard.section.buttons.val) do
    button.opts.hl = "AlphaButtons"
    button.opts.hl_shortcut = "AlphaShortcut"
  end

  dashboard.section.footer.opts.hl = "Type"
  dashboard.section.header.opts.hl = "AlphaHeader"
  dashboard.section.buttons.opts.hl = "AlphaButtons"
  dashboard.opts.layout[1].val = 8

  -- 启动时间统计
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted",
    callback = function()
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      dashboard.section.footer.val = "⚡ Neovim has initialized " .. stats.count .. " plugins，with " .. ms .. "ms"
      pcall(vim.cmd.AlphaRedraw)
    end,
  })

  alpha.setup(dashboard.opts)
end
