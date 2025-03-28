local cfg = {
    bind = true,
    doc_lines = 10,
    floating_window = true,
    floating_window_above_cur_line = true,
    fix_pos = false,
    hint_enable = true,
    hint_prefix = "󰛩 ",
    hint_scheme = "String",
    handler_opts = {
        border = "rounded",
        max_width = 60,
    },
    always_trigger = false,
    auto_close_after = nil,
    padding = "",
    transparency = nil,
}
require "lsp_signature".setup(cfg)

require('lspconfig').clangd.setup({
    on_attach = function(client, bufnr)
        require("lsp_signature").on_attach({
            bind = true,
            handler_opts = { border = "rounded" }
        }, bufnr)
    end
})
require('lspconfig').pyright.setup({
    on_attach = function(client, bufnr)
        require("lsp_signature").on_attach({
            bind = true,
            handler_opts = { border = "rounded" }
        }, bufnr)
    end
})
