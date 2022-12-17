vim.g.mapleader = ' ' -- Set leader to space

vim.keymap.set('n', '<leader>pv', function()
  vim.cmd('Neotree toggle position=float dir=' .. vim.fn.expand('%:h:f'))
end)
vim.keymap.set('x', '<leader>p', [["_dP]])
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])
vim.keymap.set('i', '<C-c>', '<Esc>')
