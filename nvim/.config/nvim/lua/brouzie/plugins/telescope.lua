return {
	"nvim-telescope/telescope.nvim",
	branch = "master", -- using master to fix issues with deprecated to definition warnings 
    -- '0.1.x' for stable ver.
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"LinArcX/telescope-env.nvim", -- fzf over env variables
		"andrew-george/telescope-themes",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		telescope.load_extension("fzf")
		telescope.load_extension("themes")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
			},
			extensions = {
				themes = {
					enable_previewer = true,
					enable_live_preview = true,
					persist = {
						enabled = true,
						path = vim.fn.stdpath("config") .. "/lua/colorscheme.lua",
					},
				},
			},
		})

		-- Keymaps
		vim.keymap.set("n", "<leader>#", "<cmd>Telescope buffers<cr>", { desc = "Telescope buffers" })
		vim.keymap.set("n", "<leader>E", ":Telescope env<CR>", { desc = "Environment variables" })
		vim.keymap.set("n", "<leader>cc", "<cmd>Telescope git_bcommits<cr>", { desc = "Telescope recent commits" })
		vim.keymap.set("n", "<leader>M", "<cmd>Telescope man_pages<CR>", { desc = "Telescope man pages" })
		vim.keymap.set("n", "<leader>df", "<cmd>Telescope diagnostics<CR>", { desc = "Telescope workspace diagnostics" })
		vim.keymap.set("n", "<leader>pr", "<cmd>Telescope oldfiles<CR>", { desc = "Fuzzy find recent files" })
		vim.keymap.set("n", "<leader>pWs", function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word })
		end, { desc = "Find Connected Words under cursor" })

		vim.keymap.set("n", "<leader>ths", "<cmd>Telescope themes<CR>", { noremap = true, silent = true, desc = "Theme Switcher" })
    end,
}
