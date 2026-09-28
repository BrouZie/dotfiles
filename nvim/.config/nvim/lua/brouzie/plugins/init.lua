return {
    "nvim-lua/plenary.nvim", --  multiple plugins need
    "nvim-tree/nvim-web-devicons", -- file icons for fff, oil, render-markdown
    "christoomey/vim-tmux-navigator", -- tmux & split window nav
    -- fixes undefined globals
    {
        "folke/lazydev.nvim",
        lazy = "VeryLazy",
        priority = 1000,
        opts = {
            library = {
                {
                    path = "${3rd}/plenary.nvim/lua",
                    words = { "plenary" }
                },
                { path = "LazyVim" },
            },
        },
    },
}
