vim.g.python3_host_prog = "~/.venvs/nvim/bin/python" -- Viktig for python provider

require("vim._core.ui2").enable({
	enable = true,
	msg = {
		target = "cmd",
		pager = { height = 0.5 },
		dialog = { height = 0.5 },
		cmd = { height = 0.5 },
		msg = { height = 0.5, timeout = 4500 },
	}
})

require("brouzie.core.options")
require("brouzie.core.keymaps")
require("brouzie.lazy")
require("current-theme")
require("brouzie.terminalpop")
require("brouzie.todopop")
