return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"LinArcX/telescope-env.nvim", -- fzf over env variables
		"andrew-george/telescope-themes" -- fzf themes
	},

	keys = {
		{ "<leader>g", "<cmd>Telescope live_grep<cr>", desc = "Telescope live grep" },
		-- { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Telescope find files" },
		{ "<leader>F", "<cmd>Telescope git_files<cr>", desc = "Telescope git files" },
		{ "<leader>M", "<cmd>Telescope man_pages<cr>", desc = "Telescope man pages" },
		{ "<leader>#", "<cmd>Telescope buffers<cr>", desc = "Telescope buffers" },
		{ "<leader>r", "<cmd>Telescope oldfiles<cr>", desc = "Telescope recent files" },

		-- word under cursor, no telescope require needed:
		{
			"<leader>pws",
			function()
				local word = vim.fn.expand("<cWORD>")
				vim.cmd(("Telescope grep_string search=%q"):format(word))
			end,
			desc = "Grep WORD under cursor",
		},
		-- Additional telescope binds
		{ "<leader>ths", "<cmd>Telescope themes<CR>", desc = "Colorscheme picker" },
		{ "<leader>E", ":Telescope env<CR>", desc = "Environment variables" },
	},

	config = function()
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				sorting_strategy = "ascending",
				path_displays = { "smart" },
				preview = { treesitter = false },
				layout_config = {
					prompt_position = "top"
				},
			},
		})

		telescope.load_extension("fzf")
		pcall(telescope.load_extension, "env")
	end,
}
