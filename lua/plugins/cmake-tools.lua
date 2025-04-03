local osys = require("cmake-tools.osys")

require("cmake-tools").setup {
  -- 基础CMake配置
  cmake_command = "cmake",
  ctest_command = "ctest",
  cmake_regenerate_on_save = true,
  cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
  cmake_build_options = {},
  -- 构建目录配置
  cmake_build_directory = function()
    return osys.iswin32 and "out\\${variant:buildType}" or "out/${variant:buildType}"
  end,
  -- 编译命令配置
  cmake_soft_link_compile_commands = true,
  cmake_compile_commands_from_lsp = false,
  -- 变体消息配置
  cmake_variants_message = {
    short = { show = true },
    long = { show = true, max_length = 40 },
  },
  -- 调试配置
  cmake_dap_configuration = {
    name = "cpp",
    type = "codelldb",
    request = "launch",
    stopOnEntry = false,
    runInTerminal = true,
    console = "integratedTerminal",
  },
  -- 执行器配置（构建过程）
  cmake_executor = {
    name = "toggleterm",
    opts = {
      direction = "horizontal",
      close_on_exit = false,
      auto_scroll = true,
    },
    default_opts = {  -- 必须包含这个字段
      toggleterm = {
        direction = "horizontal",
        close_on_exit = false,
        auto_scroll = true,
      }
    }
  },
  -- 运行器配置（运行过程）
  cmake_runner = {
    name = "toggleterm",
    opts = {
      direction = "horizontal",
      close_on_exit = false,
      auto_scroll = true,
    },
    default_opts = {  -- 必须包含这个字段
      toggleterm = {
        direction = "horizontal",
        close_on_exit = false,
        auto_scroll = true,
      }
    }
  },
  -- 通知设置
  cmake_notifications = {
    runner = { enabled = true },
    executor = { enabled = true },
    spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
    refresh_rate_ms = 0,
  },
  cmake_virtual_text_support = true,
}
