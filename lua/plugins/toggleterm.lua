return {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = true,
    opts = {
        size = function (term)
            if term.direction == "horizontal" then
                return 10
            elseif term.direction == "vertical" then
                return vim.o.columns * 0.4
            end
        end,
        hide_numbers = true,
        autochdir = true,
    },
    keys = {
        { "<leader>tt", ":ToggleTerm<CR>", desc = "Open ToggleTerm" },
    },
}
