local M = {}

-- 检测当前 Python 是否属于 Conda 环境
function M.is_conda_env()
  local python_path = vim.fn.exepath(vim.g.python3_host_prog or 'python3')
  return python_path:find('anaconda3') or python_path:find('miniconda3')
end

-- 获取当前 Conda 环境名称
function M.get_current_conda_env()
  if not M.is_conda_env() then return nil end
  
  local env_name = os.getenv('CONDA_DEFAULT_ENV')
  if env_name and env_name ~= 'base' then return env_name end
  
end

return M
