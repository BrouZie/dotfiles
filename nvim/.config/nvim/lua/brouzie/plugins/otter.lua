return {
	{
		"jmbuhr/otter.nvim",
		ft = { "markdown", "markdown.mdx", "rmd" },
		opts = {
			lsp = { diagnostics = { enabled = true } },
			buffers = { set_filetype = true},
		},
		config = function(_, opts)
			require("otter").setup(opts)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "markdown", "markdown.mdx" },
				callback = function()
					require("otter").activate({ "python" }, true, true)
				end,
			})
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "rmd", "markdown.mdx" },
				callback = function()
					require("otter").activate({ "r" }, true, true)
				end,
			})
		end,
	},
}
