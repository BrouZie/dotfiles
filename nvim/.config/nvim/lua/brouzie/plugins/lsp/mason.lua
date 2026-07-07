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
				"biome",
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"debugpy",
				"clangd",
				"lua_ls",
				"bashls",
				"basedpyright",
				"ruff",
				"html",
				"cssls",
				"tailwindcss",
				"emmet_ls",
				"emmet_language_server",
				"marksman",
				"lemminx",
				"clang-format",
				"codelldb",
				"shellcheck",
				"slangd",
				-- "cmake-language-server"
				-- "r-languageserver" -- installed globally using r: install.packages("languageserver")
			},
		})
	end,
}
