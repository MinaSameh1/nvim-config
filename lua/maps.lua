vim.g.mapleader = ' ' -- Set leader to space

vim.keymap.set(
  'n',
  '<leader>pv',
  '<Cmd>Neotree float toggle reveal_force_cwd<CR>'
)
vim.keymap.set('x', '<leader>p', [["_dP]])
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])
vim.keymap.set('i', '<C-c>', '<Esc>')
vim.keymap.set('n', 'i', function()
  if #vim.fn.getline('.') == 0 then
    return [["_cc]]
  else
    return 'i'
  end
end, { expr = true, desc = 'properly indent on empty line when insert' })
