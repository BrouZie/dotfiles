return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {},
	keys = {
		{ "<leader>ts", "<cmd>TodoQuickFix<cr>", desc = "All todo comments (quickfix)" },
		{ "<leader>TS", "<cmd>TodoQuickFix keywords=TODO,FORGETNOT,FIXME,NOTE<cr>", desc = "Main todo comments (quickfix)" },
	},
}
