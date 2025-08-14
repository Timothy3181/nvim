return {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
        {
            "folke/snacks.nvim",
            config = function()
                vim.notify = require("snacks").notifier.notify
                ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
                local progress = vim.defaulttable()
                vim.api.nvim_create_autocmd("LspProgress", {
                    callback = function(ev)
                        local client = vim.lsp.get_client_by_id(ev.data.client_id)
                        local value = ev.data.params.value
                        if not client or type(value) ~= "table" then
                            return
                        end

                        local p = progress[client.id]

                        for i = 1, #p + 1 do
                            if i == #p + 1 or p[i].token == ev.data.params.token then
                                p[i] = {
                                    token = ev.data.params.token,
                                    msg = ("[%3d%%] %s%s"):format(
                                        value.kind == "end" and 100 or value.percentage or 100,
                                        value.title or "",
                                        value.message and (" **%s**"):format(value.message) or ""
                                    ),
                                    done = value.kind == "end",
                                }
                                break
                            end
                        end

                        local msg = {}
                        progress[client.id] = vim.tbl_filter(function(v)
                            return table.insert(msg, v.msg) or not v.done
                        end, p)

                        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
                        local icon = #progress[client.id] == 0 and " "
                            or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]

                        vim.notify(table.concat(msg, "\n"), "info", {
                            id = "lsp_progress_" .. client.id,
                            title = client.name,
                            icon = icon,
                            replace = true,
                        })
                    end,
                })
            end,
            opts = {
                notifier = {
                    enable = true,
                    timeout = 3000,
                    width = { min = 40, max = 0.4 },
                    height = { min = 1, max = 0.6 },
                    margin = { top = 0, right = 1, bottom = 0 },
                    padding = true,
                    sort = { "level", "added" },
                    level = vim.log.levels.TRACE,
                    icons = {
                        error = " ",
                        warn = " ",
                        info = " ",
                        debug = " ",
                        trace = " ",
                    },
                    keep = function(notif)
                        return vim.fn.getcmdpos() > 0
                    end,
                    style = "compact",
                    top_down = true,
                    date_format = "%R",
                    more_format = " ↓ %d lines ",
                    refresh = 50,
                },
            },
        },
    },
    keys = {
        {
            "<leader>yy",
            mode = { "n", "v" },
            "<cmd>Yazi<cr>",
            desc = "Open yazi in current file.",
        },
        {
            "<leader>yw",
            "<cmd>Yazi cwd<cr>",
            desc = "Open the file manager in nvim's working directory",
        },
        {
            "<leader>yt",
            "<cmd>Yazi toggle<cr>",
            desc = "Resume the last yazi session",
        },
    },
    opts = {
        open_for_directories = false,
        keymaps = {
            show_help = "<f1>",
        },
    },
    init = function ()
        vim.g.loaded_netrwPlugin = 1
    end
}
