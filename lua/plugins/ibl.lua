return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    init = function ()
        require("ibl").setup()
    end
}
