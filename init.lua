--[[
███╗   ██╗██╗   ██╗██╗███╗   ███╗
████╗  ██║██║   ██║██║████╗ ████║
██╔██╗ ██║██║   ██║██║██╔████╔██║
██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
]]

-- Mapping functions to make things easier
local utils = require('config.utils')
local nmap = utils.nmap
local vmap = utils.vmap
local imap = utils.imap
local xmap = utils.xmap
local omap = utils.omap
local cmap = utils.cmap
local nnoremap = utils.nnoremap
local inoremap = utils.inoremap
local vnoremap = utils.vnoremap

-- Vim options
vim.opt.background = 'dark'

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.hidden = true

vim.opt.termguicolors = true

vim.opt.modeline = true
vim.opt.modelines = 5

vim.opt.updatetime = 300

vim.opt.cmdheight = 1

vim.opt.smartindent = true

vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.incsearch = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

vim.opt.undodir =  vim.fn.stdpath('config') .. '/undodir'
vim.opt.undofile = true
vim.opt.undolevels = 5000

vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.mouse = 'a'
vim.opt.cc = '80'

-- Keybindings
nnoremap('<leader>fF', ':!prettier --write %<CR>') -- Format
nnoremap('<F6>',':!zathura %:r.pdf > /dev/null 2>&1 & <CR>') -- open file.pdf
nnoremap('<F10>',':setlocal spell! <CR>') -- Toggles spell(Autocorrection)
nnoremap('<Leader>w',':w<CR>') -- Saves file
nnoremap('<leader>/',':noh <CR>') -- Stops highlighting
nnoremap('<leader>cd','<Cmd>cd %:h<CR>') -- Cd to current file location

nnoremap('<leader>T',':enew<CR>') -- open new buffer
nmap('<leader>l',':bnext<CR>') -- Move to the next buffer
nmap('<leader>h',':bprevious<CR>') -- Move to the previous buffer
nmap('<leader>bq',':bp <BAR> bd #<CR>')-- Close the current buffer and move to the previous one
nmap('<leader>bl',':ls<CR>')-- Show all open buffers and their status

nmap('gx',':!open <c-r><c-a><CR>') -- Opens anything under cursor (url or file)

nmap('cg*','*Ncgn')
nnoremap('g.','/\\V<C-r>"<CR>cgn<C-a><Esc>') -- Chained with cgn, replaces the searched word with the edited one.

-- Edit config files
cmap('c!!','e ~/.config/nvim/init.lua<CR>')
cmap('cg!!','e ~/.config/nvim/ginit.vim<CR>')
cmap('p!!','e ~/.config/nvim/lua/config/plugins.lua<CR>')

-- Plugins
require('init')

-- Some plugins settings
vim.g.did_load_filetypes = 1 -- Stop file types from loading, load them using filetypes.nvim

-- Transparency setting if you use nvim transparent toggle
-- vim.g.transparent_enabled = false

-- Plugins keybindings
nnoremap('<leader>gg','<Cmd>Git<CR>')
nnoremap('<leader>gc','<Cmd>Git commit<CR>')

---- BufferLine: These commands will navigate through buffers in order regardless of which mode you are using
-- e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
nnoremap(']b',':BufferLineCycleNext<CR>')
nnoremap('[b',':BufferLineCyclePrev<CR>')
-- These commands will move the current buffer backwards or forwards in the bufferline
nnoremap( ']B',':BufferLineMoveNext<CR>')
nnoremap( '[B',':BufferLineMovePrev<CR>')
-- These commands will sort buffers by directory, language, or a custom criteria
nnoremap('be',':BufferLineSortByExtension<CR>')
nnoremap('bd',':BufferLineSortByDirectory<CR>')
-- Pick buffer
nnoremap('<leader>gb', ':BufferLinePick<CR>')

----  Easy Align
-- Start interactive EasyAlign in visual mode (e.g. vipga)
xmap('ga','<Plug>(EasyAlign)')
-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
nnoremap('ga','<Plug>(EasyAlign)')

---- Autocomplete using cmp
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

---- Utlisnips settings
vim.g.UltiSnipsExpandTrigger="<tab>"
vim.g.UltiSnipsJumpForwardTrigger="<c-j>"
vim.g.UltiSnipsJumpBackwardTrigger="<c-k>"

-- If you want :UltiSnipsEdit to split your window.
vim.g.UltiSnipsEditSplit="vertical"

-- Location of snips
vim.g.UltiSnipsSnippetDirectories = {'~/.config/nvim/Snips', 'Snips'}
vim.g.UltiSnipsSnippetsDir = "~/.config/nvim/Snips"

---- Dasaboard
nmap     ( '<Leader>cn', ':<C-u>DashboardNewFile<CR>')
nnoremap ( 'Leader>ss',  ':<C-u>SessionSave<CR>')
nnoremap ( '<Leader>sl', ':<C-u>SessionLoad<CR>')

vim.g.dashboard_default_executive ='telescope'
nnoremap('<leader>cn','<C-u>DashboardNewFile<CR>')

-- Dasaboard Sessions
nnoremap('<leader>ss','<C-u>SessionSave<CR>')
nnoremap('<leader>sl','<C-u>SessionSave<CR>')

-- Test emote support: should be white skull 💀

vim.cmd [[
  " To make saving write protected files easier, make sure to set SUDO_ASKPASS!
  com -bar W exe 'w !sudo tee >/dev/null %:p:S' | setl nomod

  set nobackup
  set noshowmode
  set noerrorbells
  set nowritebackup
  set noswapfile
  set nowrap
  set nohlsearch

  colorscheme tokyonight
" For more checkout https://github.com/glepnir/dashboard-nvim/wiki/Ascii-Header-Text
" Dashboard
  let g:dashboard_custom_shortcut={
  \ 'last_session'       : 'leader s l',
  \ 'find_history'       : 'leader f h',
  \ 'find_file'          : 'leader f f',
  \ 'new_file'           : 'leader c n',
  \ 'change_colorscheme' : 'leader t c',
  \ 'find_word'          : 'leader f a',
  \ 'book_marks'         : 'leader f B',
  \ }

]]
