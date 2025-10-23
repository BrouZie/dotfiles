-- Run python with uv
vim.keymap.set('n', '<space>X', function()
  vim.cmd('w') -- save
  vim.cmd('belowright split | resize 12')
  vim.cmd('terminal uv run python ' .. vim.fn.shellescape(vim.fn.expand('%')))
end, { desc = 'Run current Python file with uv' })
