return {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = true,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    ---@module 'render-markdown'
    ft = { "markdown", "norg", "rmd", "org", "quarto" },
    init = function()
        -- Define colors
        local color1_bg = "#ff757f"
        local color2_bg = "#4fd6be"
        local color3_bg = "#7dcfff"
        local color4_bg = "#ff9e64"
        local color5_bg = "#7aa2f7"
        local color6_bg = "#c0caf5"
        local color_fg = "#1F2335"

        -- force treesitter highlighting for markdown buffers
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown",
            callback = function()
                vim.treesitter.start()
            end,
        })
    end,
    opts = {
        restart_highlighter = true,
        heading = {
            sign = false,
            icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
            backgrounds = {
                "Headline1Bg",
                "Headline2Bg",
                "Headline3Bg",
                "Headline4Bg",
                "Headline5Bg",
                "Headline6Bg",
            },
            foregrounds = {
                "Headline1Fg",
                "Headline2Fg",
                "Headline3Fg",
                "Headline4Fg",
                "Headline5Fg",
                "Headline6Fg",
            },
        },
        code = {
            sign = false,
            width = "block",
            right_pad = 1,
        },
        bullet = {
            -- Turn on / off list bullet rendering
            enabled = true,
        },
        html = {
            comment = {
                conceal = false,
            },
        },
    },
}
