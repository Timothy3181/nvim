return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
        "saghen/blink.cmp",
    },
    config = function()
        -- Mason manages pyright. clangd is already installed on the system,
        -- so it is intentionally not included in ensure_installed.
        require("mason-lspconfig").setup({
            ensure_installed = { "pyright", "lua_ls", "rust_analyzer" },
            automatic_enable = false,
        })

        -- Nvim 0.11+ (including 0.12) uses the native LSP API. The server
        -- defaults come from nvim-lspconfig, and these calls enable them.
        -- Keep snippetSupport enabled so clangd can return its complete set of
        -- candidates (including preprocessor completions). blink.cmp converts
        -- the unwanted template-style items to plain text below.
        local capabilities = require("blink.cmp").get_lsp_capabilities()
        vim.lsp.config("clangd", {
            capabilities = capabilities,
            -- clangd then inserts printf() rather than printf(type name).
            cmd = { "clangd", "--function-arg-placeholders=0" },
        })
        vim.lsp.config("pyright", {
            capabilities = capabilities,
        })
        vim.lsp.config("rust_analyzer", {
            capabilities = capabilities,
        })
        vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT",
                    },
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME,
                            vim.fn.stdpath("data") .. "/lazy",
                        },
                    },
                    completion = {
                        callSnippet = "Disable",
                        keywordSnippet = "Disable",
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        })
        vim.lsp.enable({ "clangd", "pyright", "lua_ls", "rust_analyzer" })
    end,
}
