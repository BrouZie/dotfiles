-- Fuzzy pickers with preview for everything that isn't files/grep (that's fff).
-- LSP pickers (gd, gR, gO, ...) are mapped in 'plugins/lsp/lspconfig.lua'.

-- Environment variables: preview shows the value (PATH-like ones one per line),
-- <CR> copies the value to the clipboard
local pick_env = function()
	local env = vim.fn.environ()
	local names = vim.tbl_keys(env)
	table.sort(names)
	require("fzf-lua").fzf_exec(names, {
		prompt = "Env> ",
		preview = function(selected)
			local name = selected[1]
			return name:match("PATH$") and (env[name]:gsub(":", "\n")) or env[name]
		end,
		actions = {
			["default"] = function(selected)
				vim.fn.setreg("+", env[selected[1]])
				vim.notify("Copied $" .. selected[1])
			end,
		},
	})
end

return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "FzfLua",
	init = function()
		-- Use fzf-lua for every `vim.ui.select()` (code actions, etc.), loading it on first use
		vim.ui.select = function(...)
			require("fzf-lua").register_ui_select()
			return vim.ui.select(...)
		end
	end,
	opts = {},
	keys = {
		{ "<leader>#",   "<Cmd>FzfLua buffers<CR>",               desc = "Buffers" },
		{ "<leader>$",   pick_env,                                desc = "Environment variables" },
		{ "<leader>'",   "<Cmd>FzfLua resume<CR>",                desc = "Resume last picker" },
		{ "<leader>df",  "<Cmd>FzfLua diagnostics_workspace<CR>", desc = "Workspace diagnostics" },
		{ "<leader>gb",  "<Cmd>FzfLua git_branches<CR>",          desc = "Git branches" },
		{ "<leader>gc",  "<Cmd>FzfLua git_bcommits<CR>",          desc = "Git commits of current file" },
		{ "<leader>gs",  "<Cmd>FzfLua git_status<CR>",            desc = "Git changed files" },
		{ "<leader>gh",  "<Cmd>FzfLua git_hunks<CR>",             desc = "Git hunks (all files)" },
		{ "<leader>gw",  "<Cmd>FzfLua git_worktrees<CR>",         desc = "Git worktrees (<C-a> add, <C-x> delete)" },
		{ "<leader>gz",  "<Cmd>FzfLua git_stash<CR>",             desc = "Git stash" },
		{ "<leader>h",   "<Cmd>FzfLua helptags<CR>",              desc = "Help pages" },
		{ "<leader>M",   "<Cmd>FzfLua manpages<CR>",              desc = "Man pages" },
		{ "<leader>ths", "<Cmd>FzfLua colorschemes<CR>",          desc = "Colorschemes" },
	},
}
