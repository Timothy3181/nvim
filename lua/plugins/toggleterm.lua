require("toggleterm").setup{
    
}

local function get_conda_env()
  -- 方法1：优先从 CONDA_DEFAULT_ENV 环境变量获取
  local env = os.getenv("CONDA_DEFAULT_ENV")
  if env and env ~= "base" then return env end

  -- 方法2：从 Python 路径解析（备用方案）
  local python_path = vim.fn.exepath(vim.g.python3_host_prog or "python3")
  return python_path:match("envs/([^/]+)")
end

require("toggleterm").setup({
  -- 禁用所有样式覆盖，保持终端原生外观
  highlights = { Normal = { link = "Normal" } },
  shade_terminals = false,
  persist_size = false,

  on_open = function(term)
    -- 自动检测 Conda 路径（兼容 Homebrew 和官方安装）
    local conda_paths = {
      "/opt/anaconda3",                   -- 你的自定义路径
      os.getenv("CONDA_PREFIX") and vim.fn.fnamemodify(os.getenv("CONDA_PREFIX"), ":h:h"), -- 从环境变量推导
      "/usr/local/anaconda3",              -- Homebrew 可能路径
      os.getenv("HOME") .. "/anaconda3"    -- 用户目录安装
    }

    local activate_script
    for _, path in ipairs(conda_paths) do
      if path then
        local candidate = path .. "/bin/activate"
        if vim.fn.filereadable(candidate) == 1 then
          activate_script = candidate
          break
        end
      end
    end

    if not activate_script then
      vim.notify("Conda activate script not found!", vim.log.levels.WARN)
      return
    end

    local env_name = get_conda_env() or "reqenv"
    
    -- 关键修改：不覆盖 PS1，让终端保持原生样式
    term:send(
      string.format("source '%s' %s && clear\n",  -- 移除了 PS1 修改
      activate_script, env_name),
      false
    )
  end
})
