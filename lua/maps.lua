-- Do not include maps that require plugins here (Ex: require('config.lsp').maps)
vim.g.mapleader = ' ' -- Set leader to space

local utils = require('config.utils')

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

-- Suggested global maps
--- Overriden by <C-W>d -> vim.diagnostic.open_float()
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, {
--   silent = true,
--   noremap = true,
--   desc = 'Open diagnostic float',
-- })
--- Overriden by ]d and [d -> vim.diagnostic.goto_next()
-- vim.keymap.set('n', '[c', vim.diagnostic.goto_prev, {
--   silent = true,
--   noremap = true,
--   desc = 'goto prev diagnostic',
-- })
-- vim.keymap.set('n', ']c', vim.diagnostic.goto_next, {
--   silent = true,
--   noremap = true,
--   desc = 'goto next diagnostic',
-- })
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, {
  silent = true,
  noremap = true,
  desc = 'set loclist',
})

vim.keymap.set( -- Cd to current file location
  'n',
  '<leader>cd',
  '<cmd> SearchAndCdForFile<CR>',
  { silent = true, noremap = true, desc = 'Cds to current opened file' }
)

vim.keymap.set(
  'n',
  '<leader>yp',
  utils.insertFullPath,
  { noremap = true, silent = true }
)

vim.keymap.set(
  'n',
  ']b',
  '<cmd>bnext<CR>',
  { silent = true, noremap = true, desc = 'Next buffer' }
)

vim.keymap.set(
  'n',
  '[b',
  '<cmd>bprevious<CR>',
  { silent = true, noremap = true, desc = 'Previous buffer' }
)

vim.keymap.set('n', 'i', function()
  if #vim.fn.getline('.') == 0 then
    return [["_cc]]
  else
    return 'i'
  end
end, { expr = true, desc = 'properly indent on empty line when insert' })
