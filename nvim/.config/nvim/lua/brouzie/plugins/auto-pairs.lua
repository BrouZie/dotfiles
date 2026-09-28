return {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    config = function()
        local autopairs = require("nvim-autopairs") -- import nvim-autopairs

        -- setup autopairs
        -- (brackets after completing a function are handled by blink.cmp's auto_brackets)
        autopairs.setup({
            check_ts = true, -- treesitter enabled
            ts_config = {
                lua = { "string" }, -- dont add pairs in lua string treesitter nodes
            },
        })
    end,
}
