vim.g.mapleader = ' ' -- Set leader to space

vim.keymap.set(
  'x',
  '<leader>p',
  [["_dP]],
  { silent = true, noremap = true, desc = 'Paste over visual selection' }
)
vim.keymap.set(
  { 'n', 'v' },
  '<leader>y',
  [["+y]],
  { silent = true, noremap = true, desc = 'Yank to clipboard' }
)
vim.keymap.set(
  'n',
  '<leader>Y',
  [["+Y]],
  { silent = true, noremap = true, desc = 'Yank to clipboard' }
)
vim.keymap.set(
  'i',
  '<C-c>',
  '<Esc>',
  { silent = true, noremap = true, desc = 'Esc' }
)
-- Navigate quickfix list
vim.keymap.set(
  'n',
  '<a-j>',
  '<cmd>cnext<cr>',
  { silent = true, noremap = true, desc = 'next quickfix' }
)
vim.keymap.set(
  'n',
  '<a-k>',
  '<cmd>cprev<cr>',
  { silent = true, noremap = true, desc = 'next quickfix' }
)

vim.keymap.set('n', 'i', function()
  if #vim.fn.getline('.') == 0 then
    return [["_cc]]
  else
    return 'i'
  end
end, { expr = true, desc = 'properly indent on empty line when insert' })
