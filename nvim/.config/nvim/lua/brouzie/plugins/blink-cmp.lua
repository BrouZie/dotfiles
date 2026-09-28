return {
    "saghen/blink.cmp",
    version = "v1.*",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    opts = {
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
        appearance = {
            nerd_font_variant = "mono",
        },
        sources = {
            default = { "lsp", "path", "buffer", "snippets" },
        },
    },
}
