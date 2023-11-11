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
-- local xmap = utils.xmap
-- local omap = utils.omap
local cmap = utils.cmap
local nnoremap = utils.nnoremap
-- local inoremap = utils.inoremap
local vnoremap = utils.vnoremap
-- Test emote support: should be white skull 💀

-- Vim options
vim.opt.background = 'dark' -- "\"dark\" or \"light\", used for highlight colors"

vim.opt.splitbelow = true -- new window from split is below the current one
vim.opt.splitright = true -- new window is put right of the current one

vim.opt.hidden = true -- don't unload buffer when it is |abandon|ed

vim.opt.termguicolors = true -- Terminal true color support

vim.opt.modeline = true -- recognize modelines at start or end of file
vim.opt.modelines = 5 -- number of lines checked for modelines

vim.opt.updatetime = 150 -- after this many milliseconds flush swap file

vim.opt.cmdheight = 0 -- number of lines to use for the command-line

vim.opt.smartcase = true -- no ignore case when pattern has uppercase
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.incsearch = true -- highlight match while typing search pattern

vim.opt.expandtab = true -- use spaces when <Tab> is inserted
vim.opt.shiftwidth = 2 -- number of spaces to use for (auto)indent step
vim.opt.tabstop = 2 -- number of spaces that <Tab> in file uses
vim.opt.softtabstop = 2 -- number of spaces that <Tab> uses while editing
vim.opt.smartindent = true -- smart autoindenting for C programs
-- vim.opt.autoindent = true
vim.opt.copyindent = true
vim.opt.wrap = false -- lines wrap and continue on the next line

vim.opt.undodir = utils.config_location .. '/undodir' -- where to store undo files
vim.opt.undofile = true -- save undo information in a file
vim.opt.undolevels = 5000 -- maximum number of changes that can be undone

vim.opt.lazyredraw = true -- don't redraw while executing macros

vim.opt.relativenumber = true -- show relative line number in front of each line
vim.opt.number = true -- show relative line number in front of each line
vim.opt.scrolloff = 8 -- minimum nr. of lines above and below cursor
vim.opt.mouse = 'a' -- the use of mouse clicks
vim.opt.colorcolumn = '80' -- columns to highlight

vim.opt.showmode = false -- message on status line to show current mode
vim.opt.backup = false -- keep backup file after overwriting a file
vim.opt.errorbells = false -- ring the bell for error messages
vim.opt.writebackup = false -- make a backup before overwriting a file
vim.opt.swapfile = false -- whether to use a swapfile for a buffer
vim.opt.hlsearch = true --  highlight matches with last search pattern
vim.opt.laststatus = 3 -- global status line

vim.opt.clipboard = 'unnamedplus'

---- Keybindings
require('maps')
nnoremap(
  '<F6>',
  ':!zathura %:r.pdf > /dev/null 2>&1 & <CR>',
  { desc = 'open pdf file (Same name as file)' }
) -- open file.pdf
nnoremap('<F10>', ':setlocal spell! <CR>', { desc = 'starts autocorrection' }) -- Toggles spell(Autocorrection)
nnoremap('<leader>w', ':w<CR>', { desc = 'saves file' }) -- Saves file
nnoremap('<leader>/', ':noh <CR>', { desc = 'stops highlighting search' }) -- Stops highlighting
nnoremap( -- Cd to current file location
  '<leader>cd',
  '<Cmd>cd %:h<CR>',
  { desc = 'Cds to current opened file' }
)
nnoremap('<leader>T', ':enew<CR>', { desc = 'Open a new buffer' }) -- open new buffer, normally I use it to hold a json obj to format!
nmap('<leader>l', ':bnext<CR>', { desc = 'Move to next buffer' }) -- Move to the next buffer
nmap('<leader>h', ':bprevious<CR>', { desc = 'Move to the prev buffer' }) -- Move to the previous buffer
nmap('<leader>bq', ':bp <BAR> bd #<CR>', { desc = 'Close the current buffer' }) -- Close the current buffer and move to the previous one
nmap( -- Close the current buffer and move to the previous one
  '<leader>bQ',
  ':bp <BAR> bd! #<CR>',
  { desc = 'Force close the current buffer' }
)
nmap( -- Close all buffers except this one
  '<leader>bd',
  ':silent %bd|e#|bd#<CR>',
  { desc = 'Close all buffers except one' }
)
nmap('<leader>bl', ':ls<CR>', { desc = 'List all buffers' }) -- List all buffers

nmap('gx', ':!open <c-r><c-a><CR>', { desc = 'Open url or file under cursor' }) -- Opens anything under cursor (url or file)

nnoremap(
  'cg*',
  '*``Ncgn',
  { desc = 'Change all searched words with previous edit' }
) -- Chained with cgn, replaces the searched word with the edited one.
nnoremap(
  'g.',
  '/\\V<C-r>"<CR>cgn<C-a><Esc>',
  { desc = 'Changes one searched word with previous edit' }
) -- Chained with cgn, replaces the searched word with the edited one.

-- Edit config files
cmap(
  'c!!',
  'e ' .. utils.config_location .. '/init.lua<CR>',
  { desc = 'Edit this file' }
) -- Edit this file
cmap(
  'cg!!',
  'e ' .. utils.config_location .. '/ginit.vim<CR>',
  { desc = 'Edit the ginit file' }
) -- Edit the gui file
cmap(
  'p!!',
  'e ' .. utils.config_location .. '/lua/plugins/init.lua<CR>',
  { desc = 'Edit plugins file' }
) -- the Plugins file using packer

-- Disable these plugins for faster startup
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_spec = 1
vim.g.loaded_perl_provider = 1 -- Perl provider
vim.g.loaded_ruby_provider = 1 -- Ruby provider
vim.g.loaded_python_provider = 1 -- Python provider
vim.g.loaded_node_provider = 1 -- Node provider

-- Distinguish between Ctrl-i and Tab when using kitty
if vim.env.TERM == 'xterm-kitty' or vim.env.TERM == 'screen-256color' then
  vim.cmd(
    [[autocmd UIEnter * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]]
  )
  vim.cmd(
    [[autocmd UILeave * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]]
  )
end

--[[
-- ****************************
-- *         Plugins          *
-- ****************************
--]]
require('init')

-- **********************************
-- *         Vim Commands           *
-- **********************************
vim.cmd([[
  " To make saving write protected files easier, make sure to set SUDO_ASKPASS!
  com -bar W exe 'w !sudo tee >/dev/null %:p:S' | setl nomod
  command! BufOnly silent! execute "%bd|e#|bd#"
]])
