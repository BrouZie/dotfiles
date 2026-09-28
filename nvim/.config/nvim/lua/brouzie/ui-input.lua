-- Floating replacement for `vim.ui.input()`, opened just below the cursor.
-- Used by `grn` (LSP rename) and anything else that asks for text input.
-- <CR> confirms, <Esc> / <C-c> cancels (from Insert and Normal mode).
vim.ui.input = function(opts, on_confirm)
	opts = opts or {}
	local default = opts.default or ""
	local prompt = (opts.prompt or "Input"):gsub("[:>]?%s*$", "")

	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = "wipe"
	vim.b[buf].completion = false -- No blink.cmp menu inside the prompt
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { default })

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "cursor",
		row = 1,
		col = 0,
		width = math.max(30, #prompt + 4, #default + 10),
		height = 1,
		style = "minimal",
		title = " " .. prompt .. " ",
	})

	local done = false
	local finish = function(value)
		if done then return end
		done = true
		vim.cmd("stopinsert")
		if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
		on_confirm(value)
	end

	local map = function(modes, lhs, fn) vim.keymap.set(modes, lhs, fn, { buffer = buf, nowait = true }) end
	map({ "i", "n" }, "<CR>", function() finish(vim.api.nvim_get_current_line()) end)
	map({ "i", "n" }, "<Esc>", function() finish(nil) end)
	map({ "i", "n" }, "<C-c>", function() finish(nil) end)
	-- Clicking/jumping away counts as cancel
	vim.api.nvim_create_autocmd("WinLeave", { buffer = buf, once = true, callback = function() finish(nil) end })

	vim.cmd("startinsert!")
end
