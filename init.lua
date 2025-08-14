vim.g.mapleader = " "

-- set floating window
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.max_width = 80
    opts.max_height = 20
    opts.border = "rounded"
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- lsp
require("lsp.lua_ls")
require("lsp.clangd")
require("lsp.pyright")
require("lsp.rust-analyzer")
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        -- keymap
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = event.buf, desc = 'LSP: Go to definition' })
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = event.buf, desc = 'LSP: Go to declaration' })
        -- diagnostics
        vim.diagnostic.config {
            virtual_text = true
        }
        -- show diagnostics a float window
        vim.keymap.set('n', '<leader>ld', function()
            vim.diagnostic.open_float { source = true }
        end, { buffer = event.buf, desc = 'LSP: Show diagnostics' })
        -- toggle diagnostics
        vim.keymap.set('n', '<leader>td', (
            function()
                local diag_status = 1
                return function()
                    if diag_status == 1 then
                        diag_status = 0
                        vim.diagnostic.config { underline = false, virtual_text = false, signs = false, update_in_insert = false }
                    else
                        diag_status = 1
                        vim.diagnostic.config { underline = true, virtual_text = true, signs = true, update_in_insert = true }
                    end
                end
            end
        )(), { buffer = event.buf, desc = 'LSP: Toggle diagnostic' })
    end,
})

-- options
require("options")

-- lazy
require("configs.lazy")
