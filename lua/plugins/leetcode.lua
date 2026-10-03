return {
    "kawre/leetcode.nvim",
    cmd = "Leet",
    keys = {
        {
            "<leader>ll",
            "<cmd>Leet<cr>",
            desc = "LeetCode",
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        lang = "cpp",
        cn = {
            enabled = true,
            translator = true,
            translate_problems = true,
        },
        plugins = {
            non_standalone = true,
        },
        picker = {
            provider = "snacks-picker",
        },
    },
}
