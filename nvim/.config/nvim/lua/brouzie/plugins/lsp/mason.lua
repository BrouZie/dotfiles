return {
    "mason-org/mason.nvim",
    lazy = false,
    dependencies = {
        "mason-org/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "neovim/nvim-lspconfig",
    },
    config = function()
        -- import mason and mason_lspconfig
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")

        -- enable mason and configure icons
        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

		-- Provides mason-names e.g: 'lua_ls' instead of 'lua-language-server'
		mason_lspconfig.setup({
			automatic_enable = false,
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- "tree-sitter-cli", -- NOTE: IMPORTANT FOR MAKING TREESITTER WORK!
				"stylua", -- lua formatter
				"clangd",
				"lua_ls",
				"bashls",
				"basedpyright",
				"ruff",
				"marksman",
				"clang-format",
				"shellcheck",
				"shfmt",
				-- "cmake-language-server"
			},
		})
	end,
}
