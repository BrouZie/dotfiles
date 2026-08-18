return {
	"j-hui/fidget.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		progress = {
			display = {
				render_limit = 0,
			},
		},
	},
}
