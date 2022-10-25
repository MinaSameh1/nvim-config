--[[
-- **************************
-- *         Plugins        *
-- **************************
--]]

local utils = require('config.utils')
local xmap = utils.xmap
local nnoremap = utils.nnoremap

-- vimtex, Must be loaded before filetype
vim.g.vimtex_view_method = 'zathura'
vim.g.tex_flavor = 'latex'
vim.opt.conceallevel = 1
-- Fuigitive
nnoremap('<leader>gg', '<Cmd>Git<CR>') -- fugitive Git window
nnoremap('<leader>gc', '<Cmd>Git commit<CR>') -- Commit

-- Easy Align
xmap('ga', '<Plug>(EasyAlign)') -- Start interactive EasyAlign in visual mode (e.g. vipga)
nnoremap('ga', '<Plug>(EasyAlign)') -- Start interactive EasyAlign for a motion/text object (e.g. gaip)

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

---- Ultisnips
---- These keybindings are useless since I use cmp
-- vim.g.UltiSnipsExpandTrigger="<tab>"
-- vim.g.UltiSnipsJumpForwardTrigger="<c-j>"
-- vim.g.UltiSnipsJumpBackwardTrigger="<c-k>"
--
-- vim.g.UltiSnipsEditSplit = 'vertical' -- If you want :UltiSnipsEdit to split your window.
--
-- vim.g.UltiSnipsSnippetDirectories = { '~/.config/nvim/Snips', 'Snips' }
-- vim.g.UltiSnipsSnippetsDir = '~/.config/nvim/Snips' -- Location of snips
-- vim.g.UltiSnipsListSnippets = '<C-Space>'

vim.g.dashboard_default_executive = 'telescope' -- Use telescope

-- Focus
vim.api.nvim_set_keymap(
  'n',
  '<leader>S',
  ':FocusSplitNicely<CR>',
  { silent = true }
)

require('config.plugins')
require('config.colorscheme')
require('colors.colors')

-- Colorscheme
require('NeoSolarized').setup({
  style = 'dark',
  transparent = false,
})
vim.cmd([[
  try
    colorscheme NeoSolarized
  catch /^Vim\%((\a\+)\)\=:E18o
    colorscheme default
    set background=dark
  endtry
]])
