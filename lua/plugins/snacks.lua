return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        input = { enabled = true },
        notifier = {
            enabled = true,
            timeout = 3000,
        },
        picker = {
            enabled = true,
            focus = "list",
            sources = {
                files = {
                    hidden = true,
                    ignored = false,
                },
            },
        },
        quickfile = { enabled = true },
    },
    config = function(_, opts)
        require("snacks").setup(opts)

        local function set_blue_borders()
            local border = { fg = "#89b4fa", bg = "NONE" }
            local groups = {
                "SnacksInputBorder",
                "SnacksPickerBorder",
                "SnacksPickerInputBorder",
                "SnacksPickerListBorder",
                "SnacksPickerPreviewBorder",
                "SnacksNotifierBorderDebug",
                "SnacksNotifierBorderError",
                "SnacksNotifierBorderInfo",
                "SnacksNotifierBorderTrace",
                "SnacksNotifierBorderWarn",
            }

            for _, group in ipairs(groups) do
                vim.api.nvim_set_hl(0, group, border)
            end
        end

        set_blue_borders()
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("SnacksBlueBorders", { clear = true }),
            callback = set_blue_borders,
        })
    end,
    keys = {
        {
            "<leader>ff",
            function()
                Snacks.picker.files()
            end,
            desc = "Find files",
        },
        {
            "<leader>fg",
            function()
                Snacks.picker.grep()
            end,
            desc = "Live grep",
        },
        {
            "<leader>fb",
            function()
                Snacks.picker.buffers()
            end,
            desc = "Buffers",
        },
    },
}
