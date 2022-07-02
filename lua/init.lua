-- vimtex, Must be loaded before filetype
vim.g.vimtex_view_method = 'zathura'
vim.g.tex_flavor = 'latex'
vim.opt.conceallevel = 1

require('config.plugins')
require('config.colorscheme')
require('colors.colors')

vim.cmd([[
colorscheme rose-pine
]])
