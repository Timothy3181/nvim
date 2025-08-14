return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
        require("nvim-autopairs").setup({
            check_ts = true,
            enable_check_bracket_line = true,
            map_cr = true,
        })

        local npairs = require("nvim-autopairs")
        local Rule = require("nvim-autopairs.rule")
        local ts_conds = require("nvim-autopairs.ts-conds")

        npairs.add_rules({
            Rule("{", "}", "c")
                :with_pair(ts_conds.is_ts_node({"block", "function_definition"}))
                :with_cr(function() return true end)
                :use_key("\r")
        })
    end
}
