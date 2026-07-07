return {
    {
        "saghen/blink.cmp",
        version = "v1.*",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
            "saghen/blink.compat",        -- bridges nvim-cmp sources to blink
        },
        config = function()
            require("blink.cmp").setup({
                fuzzy = {
                    implementation = "prefer_rust",
                },
                keymap = {
                    preset = "default",
                },
                completion = {
                    menu = {
                        auto_show = true,
                    },
                    documentation = {
                        auto_show = true,
                    },
                    ghost_text = {
                        enabled = false,
                        show_with_menu = false,
                    },
                    accept = {
                        auto_brackets = {
                            enabled = true,
                        },
                    },
                },
                cmdline = {
                    enabled = true,
                    keymap = { preset = "cmdline" },
                    completion = {
                        menu = { auto_show = true },
                    },
                },
                sources = {
                    default = { "lsp", "path", "buffer", "snippets" },

                    -- filetype overrides: swap in otter for markdown
                    per_filetype = {
                        markdown = { "otter", "snippets", "buffer", "path" },
                        ["markdown.mdx"] = { "otter", "snippets", "buffer", "path" },
                    },

                    providers = {
                        lsp = {
                            opts = {
                                tailwind_color_icon = "󱓻"
                            }
                        },

                        -- otter registered as a compat (nvim-cmp) source
                        otter = {
                            name = "otter",
                            module = "blink.compat.source",
                        },
                    },
                },
                appearance = {
                    use_nvim_cmp_as_default = false,
                    nerd_font_variant = "mono",
                },
                snippets = {
                    preset = "luasnip"
                },
            })
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },

    -- blink.compat needs its own spec entry so lazy loads it properly
    {
        "saghen/blink.compat",
        version = "v1.*",   -- pin alongside blink.cmp
        lazy = true,
        opts = {},          -- required even if empty
    },
}
