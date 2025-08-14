return {
    'goolord/alpha-nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons'
    },
    config = function ()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        local logo = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
        ]]
        dashboard.section.header.val = vim.split(logo, "\n")
        dashboard.section.buttons.val = {
            dashboard.button("f", " " .. " File Finder", ":Yazi <CR>"),
            dashboard.button("n", " " .. " New File", ":ene <BAR> startinsert <CR>"),
            dashboard.button("t", " " .. " Terminal", ":ToggleTerm direction=horizontal <CR>"),
            dashboard.button("z", " " .. " Lazy", ":Lazy <CR>"),
            dashboard.button("m", "󰙳 " .. " LSP Manager", ":Mason <CR>"),
            dashboard.button("q", "󰩈 " .. " Exit", ":qa <CR>"),
        }
        for _, button in ipairs(dashboard.section.buttons.val) do
            button.opts.hl = "AlphaButtons"
            button.opts.hl_shortcut = "AlphaShortcut"
        end
        dashboard.section.footer.opts.hl = "Type"
        dashboard.section.header.opts.hl = "AlphaHeader"
        dashboard.section.buttons.opts.hl = "AlphaButtons"
        dashboard.opts.layout[1].val = 8
        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyVimStarted",
            callback = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            dashboard.section.footer.val = "⚡ Neovim has initialized " .. stats.count .. " plugins，with " .. ms .. "ms"
            pcall(vim.cmd.AlphaRedraw)
            end,
        })
        alpha.setup(dashboard.opts)
    end
}
