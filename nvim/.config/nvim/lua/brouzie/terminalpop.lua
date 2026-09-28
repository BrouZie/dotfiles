-- Terminal Float State (taught by tj)
-- <Esc> in terminal mode is handled in 'core/keymaps.lua'

local state = {
	floating = {
		buf = -1,
		win = -1,
	},
}

local function create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)

	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local buf = nil
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true)
	end

	local win_config = {
		relative = "editor",
		border = "rounded",
		style = "minimal",
		width = width,
		height = height,
		col = col,
		row = row,
	}

	local win = vim.api.nvim_open_win(buf, true, win_config)

	return { buf = buf, win = win }
end

local pop_terminal = function()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = create_floating_window({ buf = state.floating.buf })
		if vim.bo[state.floating.buf].buftype ~= "terminal" then
			vim.cmd.terminal()
		end

		-- Start float terminal in insert mode
		vim.api.nvim_set_current_win(state.floating.win)
		vim.cmd("startinsert!")
	else
		vim.api.nvim_win_hide(state.floating.win)
	end
end

vim.api.nvim_create_user_command("Terminalpop", pop_terminal, {})

vim.keymap.set("n", "<space>tt", pop_terminal, { desc = "Toggle floating terminal" })
-- Not <space>tt in terminal mode: it would hold back every typed space (also in fzf)
vim.keymap.set({ "n", "t" }, "<M-t>", pop_terminal, { desc = "Toggle floating terminal" })

-- Lazygit in a float. It closes when lazygit quits (`q`). Files opened from
-- lazygit (`e`) open in this Neovim: '~/.config/lazygit/config.yml' calls
-- `LazygitEdit()` below through `nvim --server $NVIM --remote-expr`.
local lazygit = nil -- { float = { buf, win }, job, prev_win } while open

local close_lazygit = function()
	if not lazygit then return end
	local lg = lazygit
	lazygit = nil
	if vim.api.nvim_win_is_valid(lg.float.win) then vim.api.nvim_win_close(lg.float.win, true) end
	if vim.api.nvim_buf_is_valid(lg.float.buf) then vim.api.nvim_buf_delete(lg.float.buf, { force = true }) end
	vim.cmd("checktime") -- Reload files lazygit changed (discarded changes, checkouts, ...)
end

-- Open `path` at `line` in the window lazygit was started from, then close lazygit
_G.LazygitEdit = function(path, line)
	vim.schedule(function() -- Return to lazygit's `--remote-expr` call first
		local lg = lazygit
		close_lazygit()
		if lg then
			if vim.api.nvim_win_is_valid(lg.prev_win) then vim.api.nvim_set_current_win(lg.prev_win) end
			vim.fn.jobstop(lg.job)
		end
		vim.cmd("stopinsert")
		vim.cmd.edit(vim.fn.fnameescape(path))
		if line and line > 0 then vim.api.nvim_win_set_cursor(0, { math.min(line, vim.fn.line("$")), 0 }) end
	end)
	return 0
end

local pop_lazygit = function()
	local prev_win = vim.api.nvim_get_current_win()
	local float = create_floating_window({
		buf = -1,
		width = math.floor(vim.o.columns * 0.9),
		height = math.floor(vim.o.lines * 0.9),
	})
	local job = vim.fn.jobstart({ "lazygit" }, { term = true, on_exit = vim.schedule_wrap(close_lazygit) })
	lazygit = { float = float, job = job, prev_win = prev_win }
	vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>gL", pop_lazygit, { desc = "Lazygit" })
