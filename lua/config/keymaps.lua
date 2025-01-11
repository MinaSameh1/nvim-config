-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local cowboy = require('config.custom.cowboy')
cowboy.setup()

local utils = require('config.utils')

vim.keymap.set(
  'n',
  '<F6>',
  ':!zathura %:r.pdf > /dev/null 2>&1 & <CR>',
  { desc = 'open pdf file (Same name as file)' }
) -- open file.pdf
vim.keymap.set(
  'n',
  '<leader>g!',
  ':e ' .. utils.config_location .. '/ginit.vim<CR>',
  { desc = 'Edit the ginit file' }
)
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Saves current file' })

vim.keymap.set('n', '<leader>N', ':enew<CR>', { desc = 'Open a new buffer' })

vim.keymap.set(
  'n',
  '<leader>bq',
  ':bp <BAR> bd #<CR>',
  { desc = 'Close the current buffer' }
)

vim.keymap.set(
  'n',
  '<leader>bQ',
  ':bp <BAR> bd! #<CR>',
  { desc = 'Force close the current buffer' }
)

vim.keymap.set(
  'n',
  '<leader>bE',
  ':silent %bd|e#|bd#<CR>',
  { desc = 'Close all buffers except one' }
)

-- Navigate quickfix list
vim.keymap.set(
  'n',
  '<M-j>',
  '<cmd>cnext<cr>',
  { silent = true, noremap = true, desc = 'next quickfix' }
)
vim.keymap.set(
  'n',
  '<M-k>',
  '<cmd>cprev<cr>',
  { silent = true, noremap = true, desc = 'next quickfix' }
)

-- Select All
vim.keymap.set('n', '<leader><C-a>', 'gg<S-v>G')

vim.keymap.set( -- Cd to current file location
  'n',
  '<leader>cD',
  '<cmd> SearchAndCdForFile<CR>',
  { silent = true, noremap = true, desc = 'Cds to current opened file' }
)

vim.keymap.set(
  'n',
  '<leader>yp',
  utils.insertFullPath,
  { noremap = true, silent = true }
)
