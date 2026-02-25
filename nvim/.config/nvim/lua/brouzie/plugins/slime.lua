return {
	"jpalardy/vim-slime",
	config = function()
		vim.g.slime_target = "tmux"
		vim.g.slime_default_config = {
			socket_name = "default",
			target_pane = "{last}",
		}
		vim.g.slime_dont_ask_default = 1
		vim.g.slime_bracketed_paste = 1
		vim.keymap.set("n", "<leader><CR>", "<Plug>SlimeLineSend", { desc = "Send line to REPL" })
		vim.keymap.set("x", "<leader><CR>", "<Plug>SlimeRegionSend", { desc = "Send selection to REPL" })
	end,
}
