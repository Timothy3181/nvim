return {
    "linux-cultist/venv-selector.nvim",
    ft = "python",
    dependencies = {
        "folke/snacks.nvim",
    },
    keys = {
        {
            "<leader>vs",
            "<cmd>VenvSelect<cr>",
            desc = "Select Python virtual environment",
        },
    },
    opts = {
        options = {
            picker = "snacks",
            enable_cached_venvs = true,
            cached_venv_automatic_activation = true,
            activate_venv_in_terminal = true,
            set_environment_variables = true,
            notify_user_on_venv_activation = true,
        },
    },
}
