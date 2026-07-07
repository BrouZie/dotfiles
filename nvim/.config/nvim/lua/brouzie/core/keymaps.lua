vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

map("n", "<leader>GS", vim.cmd.Git)
-- map("n", "<leader>h", ":Pick help<CR>")
-- map("n", "<leader>f", ":Pick files<CR>")
map("n", "<leader>GG", ":G ")
map("n", "<leader>e", ":Oil<CR>")
map("n", "<leader>w", ":update<CR>")
map("n", "<leader>q", ":quit<CR>")
map("n", "<leader>b", ":e #<CR>")
map("t", "", "")
map("t", "", "")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Better navigation in text-type documents
map("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })

map("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

-- Panes manipulation
map("n", "<leader>v", ":vsplit<CR>")
map("n", "<leader>s", "<C-w>s<CR>")
map("n", "<leader>S", ":sf #<CR>")
map("n", "<leader>V", ":vsplit #<CR>")
map("n", "<leader>+", ":vertical resize +5<CR>")
map("n", "<leader>-", ":vertical resize -5<CR>")
map("n", "<leader>?", ":resize +5<CR>")
map("n", "<leader>_", ":resize -5<CR>")

-- cd into working directory
map("n", "<leader>cd", "<cmd>cd %:p:h|pwd<CR>")

-- Move between panes
map("n", "<c-k>", ":wincmd k<CR>")
map("n", "<c-j>", ":wincmd j<CR>")
map("n", "<c-h>", ":wincmd h<CR>")
map("n", "<c-l>", ":wincmd l<CR>")
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Indent "toggle"
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move lines collectively
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

-- Copy !pwd
map("n", "<leader>yp", function()
	local filePath = vim.fn.expand("%:~")
	vim.fn.setreg("+", filePath)
	print("File path copied to clipboard: " .. filePath)
end, { desc = "Copy file path to clipboard" })

map(
	"n",
	"<leader>rp",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor inside buffer" }
)

-- Copilot
map("i", "<C-F>", 'copilot#Accept("\\<CR>")', {
	expr = true,
	replace_keycodes = false,
})

-- Inlay hints
map("n", "<leader>H", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

-- Toggle colors
map("n", "<leader>c", ":ColorizerToggle<CR>")

-- Visual selection of markdown codeblock
map("n", "<leader>o", function()
	local start_line = vim.fn.search("^```\\S", "bnW")
	local end_line = vim.fn.search("^```\\s*$", "nW")

	if start_line > 0 and end_line > start_line + 1 then
		vim.api.nvim_win_set_cursor(0, { start_line + 1, 0 })
		vim.cmd("normal! V")
		vim.api.nvim_win_set_cursor(0, { end_line - 1, 0 })
	else
		print("You are not within a codeblock!")
	end
end, { desc = "Visual selection inside md codeblock" })
