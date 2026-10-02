return {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
        {
            "xzbdmw/colorful-menu.nvim",
            config = function()
                require("colorful-menu").setup({})
            end,
        },
    },
    init = function()
        local function set_border_highlights()
            local border = { fg = "#89b4fa", bg = "NONE" }
            vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", border)
            vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", border)
            vim.api.nvim_set_hl(0, "BlinkCmpSignatureBorder", border)
        end

        set_border_highlights()
        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = set_border_highlights,
        })
    end,
    opts = {
        -- Tab accepts the current completion; when no completion is available
        -- it falls back to the normal Tab key.
        keymap = {
            preset = "super-tab",
        },
        appearance = {
            nerd_font_variant = "mono",
        },
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
                window = {
                    border = "rounded",
                    scrollbar = true,
                    winhighlight = table.concat({
                        "Normal:NormalFloat",
                        "FloatBorder:BlinkCmpDocBorder",
                        "CursorLine:CursorLine",
                        "Search:None",
                    }, ","),
                },
            },
            ghost_text = {
                enabled = false,
            },
            list = {
                selection = {
                    preselect = false,
                    auto_insert = false,
                },
            },
            menu = {
                border = "rounded",
                min_width = 10,
                max_height = 8,
                scrollbar = true,
                winhighlight = table.concat({
                    "Normal:Pmenu",
                    "FloatBorder:BlinkCmpMenuBorder",
                    "CursorLine:PmenuSel",
                    "Search:None",
                    "CurSearch:None",
                }, ","),
                draw = {
                    padding = { 1, 1 },
                    gap = 1,
                    columns = {
                        { "kind_icon" },
                        { "label" },
                        { "kind", gap = 1 },
                    },
                    components = {
                        kind_icon = {
                            ellipsis = false,
                            text = function(ctx)
                                return ctx.kind_icon
                            end,
                            highlight = function(ctx)
                                return ctx.kind_hl
                            end,
                        },
                        label = {
                            -- Let the menu follow the longest visible label,
                            -- with a cap for unusually long paths/signatures.
                            width = { min = 1, max = 64 },
                            ellipsis = true,
                            text = function(ctx)
                                return require("colorful-menu").blink_components_text(ctx)
                            end,
                            highlight = function(ctx)
                                return require("colorful-menu").blink_components_highlight(ctx)
                            end,
                        },
                        kind = {
                            ellipsis = false,
                            text = function(ctx)
                                local names = {
                                    Class = "class",
                                    Constructor = "ctor",
                                    Enum = "enum",
                                    Field = "field",
                                    Function = "func",
                                    Interface = "iface",
                                    Keyword = "kwd",
                                    Method = "method",
                                    Module = "module",
                                    Property = "prop",
                                    Struct = "struct",
                                    TypeParameter = "type",
                                    Variable = "var",
                                }
                                return names[ctx.kind] or string.lower(ctx.kind or "")
                            end,
                            highlight = function(ctx)
                                return ctx.kind_hl
                            end,
                        },
                    },
                },
            },
        },
        signature = {
            enabled = true,
            window = {
                border = "rounded",
                winhighlight = table.concat({
                    "Normal:NormalFloat",
                    "FloatBorder:BlinkCmpSignatureBorder",
                }, ","),
            },
        },
        sources = {
            -- Keep LSP, path, and buffer completion. We selectively convert
            -- LSP snippets to plain text instead of dropping them all: clangd
            -- uses snippet-formatted items for useful preprocessor entries.
            default = { "lsp", "path", "buffer" },
            providers = {
                lsp = {
                    transform_items = function(_, items)
                        local plain_text_format = vim.lsp.protocol.InsertTextFormat.PlainText

                        local function expand_snippet(text)
                            if type(text) ~= "string" then
                                return ""
                            end

                            -- Convert common LSP snippet forms to ordinary text.
                            -- Discard placeholder defaults as well as tab
                            -- stops: foo(${1:arg}) becomes foo().
                            text = text:gsub("%${%d+:[^}]*}", "")
                            text = text:gsub("%${%d+|[^}]*|}", "")
                            text = text:gsub("%${%d+}", "")
                            text = text:gsub("%$%d+", "")
                            text = text:gsub("\\([\\$}])", "%1")
                            return text
                        end

                        local function item_text(item)
                            if type(item.textEdit) == "table" and item.textEdit.newText then
                                return item.textEdit.newText
                            end
                            return item.insertText or item.label or ""
                        end

                        return vim.tbl_filter(function(item)
                            if item.insertTextFormat ~= vim.lsp.protocol.InsertTextFormat.Snippet then
                                return true
                            end

                            local text = expand_snippet(item_text(item))
                            local is_preprocessor = (item.label or ""):match("^%s*#")
                                or text:match("^%s*#")

                            -- Preserve preprocessor completions, but make them
                            -- plain text so they never start a snippet session.
                            -- Reduce multiline/braced templates such as struct,
                            -- if, and for to their leading keyword. Keep compact
                            -- items such as printf().
                            if not is_preprocessor and (text:find("[{}]") or text:find("\n")) then
                                text = (item.label or ""):match("^([%a_][%w_]*)")
                                    or text:match("^%s*([%a_][%w_]*)")
                                    or text
                            end

                            item.insertTextFormat = plain_text_format
                            if item.insertText then
                                item.insertText = text
                            end
                            if type(item.textEdit) == "table" and item.textEdit.newText then
                                item.textEdit.newText = text
                            end
                            if item.textEditText then
                                item.textEditText = text
                            end
                            return true
                        end, items)
                    end,
                },
            },
        },
        fuzzy = {
            implementation = "prefer_rust_with_warning",
        },
    },
    opts_extend = { "sources.default" },
}
