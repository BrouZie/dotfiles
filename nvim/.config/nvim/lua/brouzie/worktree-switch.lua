-- Make `:cd` into another worktree of the same repo (e.g. via <leader>gw) act
-- like switching branches: the current file reopens in the new worktree,
-- unmodified buffers from the old worktree are closed, and LSP servers left
-- without buffers are stopped (new ones start for the new worktree).

local git = function(dir, args)
	local res = vim.system(vim.list_extend({ "git", "-C", dir }, args), { text = true }):wait()
	return res.code == 0 and vim.trim(res.stdout) or nil
end
local root_of = function(dir) return git(dir, { "rev-parse", "--show-toplevel" }) end
local repo_of = function(dir) return git(dir, { "rev-parse", "--path-format=absolute", "--git-common-dir" }) end

local old_cwd
vim.api.nvim_create_autocmd("DirChangedPre", {
	pattern = "global",
	desc = "Remember cwd before a worktree switch",
	callback = function() old_cwd = vim.fn.getcwd() end,
})

vim.api.nvim_create_autocmd("DirChanged", {
	pattern = "global",
	desc = "Move buffers and LSP to the new git worktree",
	callback = function()
		local old_root, new_root = old_cwd and root_of(old_cwd), root_of(vim.fn.getcwd())
		if not (old_root and new_root) or old_root == new_root then return end
		if repo_of(old_root) ~= repo_of(new_root) then return end -- Different repo, not a worktree

		local in_old = function(name) return name:sub(1, #old_root + 1) == old_root .. "/" end

		-- Reopen the current file in the new worktree (or open its root)
		local current = vim.api.nvim_buf_get_name(0)
		local target = in_old(current) and new_root .. current:sub(#old_root + 1) or nil
		vim.cmd.edit(vim.fn.fnameescape(target and vim.uv.fs_stat(target) and target or new_root))

		-- Close unmodified buffers from the old worktree; keep ones with unsaved changes
		local kept = 0
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.bo[buf].buflisted and in_old(vim.api.nvim_buf_get_name(buf)) then
				if vim.bo[buf].modified then
					kept = kept + 1
				else
					pcall(vim.api.nvim_buf_delete, buf, {})
				end
			end
		end

		-- Stop LSP clients that no longer have any buffers (from the old worktree)
		vim.schedule(function()
			for _, client in ipairs(vim.lsp.get_clients()) do
				if vim.tbl_isempty(client.attached_buffers) then client:stop() end
			end
		end)

		local msg = "Worktree: " .. vim.fn.fnamemodify(new_root, ":~")
		if kept > 0 then msg = msg .. (" (kept %d modified buffer(s) from old worktree)"):format(kept) end
		vim.notify(msg)
	end,
})
