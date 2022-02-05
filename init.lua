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
-- local vmap = utils.vmap
-- local imap = utils.imap
local xmap = utils.xmap
-- local omap = utils.omap
local cmap = utils.cmap
local nnoremap = utils.nnoremap
-- local inoremap = utils.inoremap
-- local vnoremap = utils.vnoremap

-- Test emote support: should be white skull 💀

-- Vim options
vim.opt.background = 'dark' -- "\"dark\" or \"light\", used for highlight colors"

vim.opt.splitbelow = true -- new window from split is below the current one
vim.opt.splitright = true -- new window is put right of the current one

vim.opt.hidden = true -- don't unload buffer when it is |abandon|ed

vim.opt.termguicolors = true -- Terminal true color support

vim.opt.modeline = true -- recognize modelines at start or end of file
vim.opt.modelines = 5 -- number of lines checked for modelines

vim.opt.updatetime = 300 -- after this many milliseconds flush swap file

vim.opt.cmdheight = 1 -- number of lines to use for the command-line


vim.opt.smartcase = true -- no ignore case when pattern has uppercase
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.incsearch = true -- highlight match while typing search pattern

vim.opt.expandtab = true -- use spaces when <Tab> is inserted
vim.opt.shiftwidth = 2 -- number of spaces to use for (auto)indent step
vim.opt.tabstop = 2 -- number of spaces that <Tab> in file uses
vim.opt.softtabstop = 2 -- number of spaces that <Tab> uses while editing
vim.opt.smartindent = true -- smart autoindenting for C programs
vim.opt.wrap = false -- lines wrap and continue on the next line

vim.opt.undodir =  vim.fn.stdpath('config') .. '/undodir' -- where to store undo files
vim.opt.undofile = true -- save undo information in a file
vim.opt.undolevels = 5000 -- maximum number of changes that can be undone

vim.opt.lazyredraw = true -- don't redraw while executing macros

vim.opt.relativenumber = true -- show relative line number in front of each line
vim.opt.scrolloff = 8 -- minimum nr. of lines above and below cursor
vim.opt.mouse = 'a' -- the use of mouse clicks
vim.opt.colorcolumn = '80' -- columns to highlight

vim.opt.showmode = false -- message on status line to show current mode
vim.opt.backup = false -- keep backup file after overwriting a file
vim.opt.errorbells = false -- ring the bell for error messages
vim.opt.writebackup = false -- make a backup before overwriting a file
vim.opt.swapfile = false -- whether to use a swapfile for a buffer
vim.opt.hlsearch = false --  highlight matches with last search pattern

vim.opt.guifont='FiraCode Nerd Font:h11' -- Font that will be used in GUI vim

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
cmap('c!!','e ~/.config/nvim/init.lua<CR>') -- Edit this file
cmap('cg!!','e ~/.config/nvim/ginit.vim<CR>') -- Edit the gui file
cmap('p!!','e ~/.config/nvim/lua/config/plugins.lua<CR>') -- the Plugins file using packer

--[[
-- ****************************
-- *         Plugins          *
-- ****************************
--]]
require('init')


--[[
-- ****************************************
-- *         Plugins Keybindings          *
-- ****************************************
--]]

-- *****************************
-- *         fugitive          *
-- *****************************
nnoremap('<leader>gg','<Cmd>Git<CR>') -- fugitive Git window
nnoremap('<leader>gc','<Cmd>Git commit<CR>') -- Commit

-- *******************************
-- *         BufferLine          *
-- *******************************
nnoremap(']b',':BufferLineCycleNext<CR>') -- Go right
nnoremap('[b',':BufferLineCyclePrev<CR>') -- Go left
nnoremap( ']B',':BufferLineMoveNext<CR>') -- Move the buffer to the right
nnoremap( '[B',':BufferLineMovePrev<CR>') -- Move the buffer to the left
nnoremap('be',':BufferLineSortByExtension<CR>') -- Sort buffer by Extension
nnoremap('bd',':BufferLineSortByDirectory<CR>') -- Sort buffer by Directory
nnoremap('<leader>gb', ':BufferLinePick<CR>') -- Pick buffer

-- *******************************
-- *         EasyAlign           *
-- *******************************
xmap('ga','<Plug>(EasyAlign)') -- Start interactive EasyAlign in visual mode (e.g. vipga)
nnoremap('ga','<Plug>(EasyAlign)') -- Start interactive EasyAlign for a motion/text object (e.g. gaip)

-- *******************************
-- *      CMP autocomplete       *
-- *******************************
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- *******************************
-- *         UltiSnips           *
-- *******************************
-- These keybindings are useless since I use cmp
-- vim.g.UltiSnipsExpandTrigger="<tab>"
-- vim.g.UltiSnipsJumpForwardTrigger="<c-j>"
-- vim.g.UltiSnipsJumpBackwardTrigger="<c-k>"

vim.g.UltiSnipsEditSplit='vertical' -- If you want :UltiSnipsEdit to split your window.

vim.g.UltiSnipsSnippetDirectories = {'~/.config/nvim/Snips', 'Snips'}
vim.g.UltiSnipsSnippetsDir = "~/.config/nvim/Snips"  -- Location of snips
vim.g.UltiSnipsListSnippets = '<C-Space>'

-- ******************************
-- *         DASHBOARD          *
-- ******************************
nmap     ( '<Leader>cn', ':<C-u>DashboardNewFile<CR>') -- Open new file
-- Dasaboard Sessions
nnoremap ( 'Leader>ss',  ':<C-u>SessionSave<CR>') -- Save Session
nnoremap ( '<Leader>sl', ':<C-u>SessionLoad<CR>') -- Load Session

vim.g.dashboard_default_executive ='telescope' -- Use telescope

-- **********************************
-- *         Vim Commands           *
-- **********************************
vim.cmd [[
  " To make saving write protected files easier, make sure to set SUDO_ASKPASS!
  com -bar W exe 'w !sudo tee >/dev/null %:p:S' | setl nomod

  colorscheme tokyonight

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
