return {
	"stevearc/oil.nvim",
    -- enabled = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
            default_file_explorer = true, -- start up nvim with oil instead of netrw
			use_default_keymaps = false,
			columns = { },
			keymaps = {
				["g?"] = { "actions.show_help", mode = "n" },
				["<CR>"] = "actions.select",
                ["<Esc>"] = "actions.close",
				["<leader>cd"] = "actions.cd",
				["<C-p>"] = "actions.preview",
				["-"] = { "actions.parent", mode = "n" },
				["_"] = { "actions.open_cwd", mode = "n" },
				["<C-s>"] = "actions.refresh",
			},
            delete_to_trash = true,
			view_options = {
				show_hidden = true,
			},
            skip_confirm_for_simple_edits = true,
		})

		-- opens parent dir over current active window
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		-- open parent dir in float window
		vim.keymap.set("n", "<leader>-", require("oil").toggle_float)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "oil", -- Adjust if Oil uses a specific file type identifier
            callback = function()
                vim.opt_local.cursorline = true
            end,
        })
	end,

}
