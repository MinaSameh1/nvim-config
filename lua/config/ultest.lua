vim.g.ultest_use_pty = 1

vim.g['test#javascript#reactscripts#options'] = '--watchAll=false'
vim.g['test#javascript#reactscripts#options'] = '--watchAll=false'
vim.g['test#typescript#reactscripts#options'] = '--watchAll=false'
vim.g['test#typescript#reactscripts#options'] = '--watchAll=false'

vim.g['test#typescript#patterns'] = vim.g['test#javascript#patterns']
vim.g['test#strategy'] = 'neovim'
vim.g['test#javascript#jest#options'] = {
  all = '--silent',
}

local nmap = require('config.utils').nmap
local nnoremap = require('config.utils').nnoremap

nmap(']t', '<Plug>(ultest-next-fail)')
nmap('[t', '<Plug>(ultest-prev-fail)')
nnoremap('<localleader>Tn', '<cmd>UltestNearest<CR>')

-- vim.g['test#typescript#jest#options'] = "--config=config/jest.config.js --detectOpenHandles"
