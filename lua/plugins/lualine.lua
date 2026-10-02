return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        {
            "catppuccin/nvim",
            name = "catppuccin",
            opts = {},
        },
    },
    opts = {
        options = {
            theme = "catppuccin-nvim",
            globalstatus = true,
            section_separators = "",
            component_separators = "│",
            disabled_filetypes = {
                "alpha",
                "dashboard",
                "NvimTree",
                "TelescopePrompt",
            },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = {
                { "filename", path = 1 },
            },
            lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
    },
}
