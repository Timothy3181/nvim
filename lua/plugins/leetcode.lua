return {
    "kawre/leetcode.nvim",
    cmd = "Leet",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        lang = "c",
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
