-- Run python with uv
--
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function()
		vim.keymap.set('n', '<space>x', function()
			vim.cmd('update') -- save
			vim.cmd('belowright split | resize 12')
			vim.cmd('terminal uv run python ' .. vim.fn.shellescape(vim.fn.expand('%')))
		end, { desc = 'Run current Python file with uv' })
  end,
})
