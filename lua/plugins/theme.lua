return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("catppuccin")
        end,
        opts = {
            flavour = "mocha",
            background = {
                light = "mocha",
                dark = "mocha",
            },
        },
    }
}
