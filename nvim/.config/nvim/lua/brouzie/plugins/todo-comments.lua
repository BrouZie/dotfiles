return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		keywords = {
			sok = { icon = " ", color = "#7aa2f7" },
			kas = { icon = " ", color = "#bb9af7" },
			FORGETNOT = { icon = " ", color = "warning" },
		},
		highlight = {
			pattern = {
				[[.*<(KEYWORDS)\s*:]], -- normal TODO:, FIXME:, etc.
				[[.*<(TODO\((KEYWORDS)\)):]], -- TODO(sok):, TODO(kas):
			},
		},
		search = {
			pattern = [[\b(KEYWORDS):|\bTODO\((KEYWORDS)\):]],
		},
	},
	keys = {
		{ "<leader>ts", "<cmd>TodoQuickFix<cr>", desc = "All todo comments (quickfix)" },
	},
}
