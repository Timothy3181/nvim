return {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "ravitemer/codecompanion-history.nvim",
        "mrjones2014/codecompanion-ui.nvim",
        "folke/snacks.nvim",
        {
            'MeanderingProgrammer/render-markdown.nvim',
            ft = { 'codecompanion', 'codecompanion_input' },
            opts = {
                heading = {
                    width = "block",
                    position = "inline",
                    border = false,
                    sign = false,
                    icons = {
                        "▎ ",
                        "▎ ",
                        "▎ ",
                        "▎ ",
                        "▎ ",
                        "▎ ",
                    },
                },
            },
        },
    },
    init = function()
        -- codecompanion-ui.nvim pins its chat windows with winfixbuf. The
        -- history extension must switch those windows to restored chat
        -- buffers, so leave these two managed filetypes switchable.
        vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "WinEnter" }, {
            pattern = "*",
            callback = function(args)
                local filetype = vim.bo[args.buf].filetype
                if not vim.tbl_contains({ "codecompanion", "codecompanion_input" }, filetype) then
                    return
                end

                vim.schedule(function()
                    for _, win in ipairs(vim.fn.win_findbuf(args.buf)) do
                        if vim.api.nvim_win_is_valid(win) then
                            vim.wo[win].winfixbuf = false
                            vim.wo[win].cursorline = false
                        end
                    end
                end)
            end,
        })
    end,
    opts = {
        adapters = {
            http = {
                gpt = function()
                    return require("codecompanion.adapters").extend("openai_responses", {
                        url = "https://ca.memofun.net/v1/responses",
                        env = {
                            api_key = "AIZEX_API_KEY",
                        },
                        schema = {
                            model = {
                                default = "gpt-5.6-sol",
                                choices = {
                                    ["gpt-5.6-sol"] = {
                                        formatted_name = "GPT-5.6-Sol",
                                        opts = {
                                            can_reason = true,
                                            can_use_tools = true,
                                        },
                                    },
                                    ["gpt-6-sol"] = {
                                        formatted_name = "GPT-6-Sol",
                                        opts = {
                                            can_reason = true,
                                            can_use_tools = true,
                                        },
                                    },
                                },
                            },
                            ["reasoning.effort"] = {
                                default = "high",
                                choices = {
                                    "low",
                                    "medium",
                                    "high",
                                    "xhigh",
                                    "max",
                                },
                            },
                        },
                    })
                end,
            },
        },
        interactions = {
            chat = {
                roles = {
                    llm = function(adapter)
                        local model = adapter.schema.model.default
                        if type(model) == "function" then
                            model = model(adapter)
                        end
                        local choice = adapter.schema.model.choices
                            and adapter.schema.model.choices[model]
                        local display_name = choice and choice.formatted_name or model
                        return "PRTS -- Based on " .. tostring(display_name)
                    end,
                },
                adapter = {
                    name = "gpt",
                    model = "gpt-5.6-sol",
                },
                sessions = {
                    enabled = false,
                },
                tools = {
                    read_file = {
                        opts = {
                            require_approval_before = false,
                        },
                    },
                    grep_search = {
                        opts = {
                            require_approval_before = false,
                        },
                    },
                    insert_edit_into_file = {
                        opts = {
                            require_confirmation_after = true,
                            protect = true,
                        },
                    },
                    create_file = {
                        opts = {
                            require_confirmation_after = true,
                            protect = true,
                        },
                    },
                    opts = {
                        default_tools = { "agent" },
                    },
                },
            },
        },
        display = {
            chat = {
                intro_message = "",
                show_settings = true,
                show_context = true,
                window = {
                    position = "right",
                    width = 0.24,
                    opts = {
                        number = false,
                        relativenumber = false,
                        signcolumn = "no",
                    },
                },
            },
        },
        extensions = {
            history = {
                enabled = true,
                opts = {
                    keymap = "gh",
                    auto_save = true,
                    auto_generate_title = false,
                    expiration_days = 0,
                    picker = "snacks",
                },
            },
            ui = {
                enabled = true,
                opts = {
                    input = {
                        winbar = {
                            { component = "model" },
                            "%=",
                            {
                                component = "spinner",
                                interval_ms = 100,
                                frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                                text = "Processing...",
                            },
                        },
                    },
                    chat = {
                        width = 0.24,
                    },
                },
            },
        },
    },
}
