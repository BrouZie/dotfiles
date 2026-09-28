-- Git: fugitive (status/commit), gitsigns (hunks in buffer), diffview (review).
-- Git pickers (branches, worktrees, ...) live in 'plugins/fzf-lua.lua' and
-- lazygit in 'brouzie/terminalpop.lua'. Overview of <leader>g:
--   ga/gA stage hunk/buffer   gr reset hunk   gp preview hunk   gB blame line
--   gg status (fugitive)   gd review changes   gH file history   gL lazygit
--   gs changed files   gb branches   gc file commits   gw worktrees
--   gh all hunks   gz stash                       ]h/[h next/prev hunk, ih = hunk
return {
	{ "tpope/vim-fugitive" },

	{ -- Git signs in the gutter + stage/reset/preview hunks right in the buffer
		"lewis6991/gitsigns.nvim",
		opts = {
			on_attach = function(buf)
				local gs = require("gitsigns")
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
				end
				local selected_lines = function() return { vim.fn.line("."), vim.fn.line("v") } end

				-- Jump between hunks (falls back to `]c`/`[c` in diff mode)
				map("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
				map("n", "[h", function() gs.nav_hunk("prev") end, "Previous hunk")

				-- stylua: ignore start
				map("n", "<leader>ga", gs.stage_hunk,                                     "Stage hunk (again = unstage)")
				map("x", "<leader>ga", function() gs.stage_hunk(selected_lines()) end,    "Stage selected lines")
				map("n", "<leader>gA", gs.stage_buffer,                                   "Stage buffer")
				map("n", "<leader>gr", gs.reset_hunk,                                     "Reset hunk")
				map("x", "<leader>gr", function() gs.reset_hunk(selected_lines()) end,    "Reset selected lines")
				map("n", "<leader>gp", gs.preview_hunk_inline,                            "Preview hunk inline")
				map("n", "<leader>gB", function() gs.blame_line({ full = true }) end,     "Blame line")
				-- stylua: ignore end

				-- Hunk text object: `vih` selects a hunk, `dih` deletes it, ...
				map({ "o", "x" }, "ih", gs.select_hunk, "Inside hunk")
			end,
		},
	},

	{ -- Review: every changed file in one tab, file history, merge conflicts
		"dlyongemallo/diffview-plus.nvim",
		version = "*",
		cmd = { "DiffviewOpen", "DiffviewToggle", "DiffviewFileHistory" },
		keys = {
			{ "<leader>gd", "<Cmd>DiffviewToggle<CR>",          desc = "Review changes (toggle)" },
			{ "<leader>gH", "<Cmd>DiffviewFileHistory %<CR>",   desc = "File history" },
			{ "<leader>gH", ":DiffviewFileHistory<CR>", mode = "x", desc = "History of selected lines" },
		},
		opts = {},
	},
}
