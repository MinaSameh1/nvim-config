-- Nvim lua

-- Mapping function to make things easier
local utils = require('config.utils')
local nmap = utils.nmap
local vmap = utils.vmap
local imap = utils.imap
local xmap = utils.xmap
local omap = utils.omap
local nnoremap = utils.nnoremap
local inoremap = utils.inoremap
local vnoremap = utils.vnoremap

vim.opt.background = 'dark'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.modeline = true
vim.opt.modelines = 5
vim.opt.updatetime = 300
vim.opt.cmdheight = 2
vim.opt.smartindent = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.undodir =  vim.fn.stdpath('config') .. '/undodir'
vim.opt.undofile = true
vim.opt.undolevels = 5000
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

vim.cmd [[
  " To make saving write protected files easier, make sure to set SUDO_ASKPASS!
  com -bar W exe 'w !sudo tee >/dev/null %:p:S' | setl nomod
  " Edit config files
  cmap c!! e ~/.config/nvim/init.vim<CR>
  cmap cg!! e ~/.config/nvim/ginit.vim<CR>

  source ~/.config/nvim/config/theme.vim

" For more checkout https://github.com/glepnir/dashboard-nvim/wiki/Ascii-Header-Text
  let g:dashboard_custom_header = [
  \ ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
  \ ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
  \ ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
  \ ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
  \ ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
  \ ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
  \]
]]

-- Plugins
require('init')

vim.g.transparent_enabled = false
-- Plugins keybindings
nnoremap('<leader>gg','<Cmd>Git<CR>')
nnoremap('<leader>gc','<Cmd>Git commit<CR>')

-- open our tagbar
nnoremap('<F3>',':TagbarToggle<CR>')

-- These commands will navigate through buffers in order regardless of which mode you are using
-- e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
nnoremap('[b',':BufferLineCycleNext<CR>')
nnoremap(']b',':BufferLineCyclePrev<CR>')

-- These commands will move the current buffer backwards or forwards in the bufferline
nnoremap( '[B',':BufferLineMoveNext<CR>')
nnoremap( ']B',':BufferLineMovePrev<CR>')


-- These commands will sort buffers by directory, language, or a custom criteria
nnoremap('be',':BufferLineSortByExtension<CR>')
nnoremap('bd',':BufferLineSortByDirectory<CR>')

-- Pick buffer
nnoremap('<leader>gb', ':BufferLinePick<CR>')
--  Settings for Easy Align "
-- Start interactive EasyAlign in visual mode (e.g. vipga)
xmap('ga','<Plug>(EasyAlign)')
-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
-- nnoremap( 'ga','<Plug>(EasyAlign)' )

vim.g.UltiSnipsExpandTrigger="<tab>"
vim.g.UltiSnipsJumpForwardTrigger="<c-j>"
vim.g.UltiSnipsJumpBackwardTrigger="<c-k>"

-- If you want :UltiSnipsEdit to split your window.
--vim.g:UltiSnipsEditSplit="vertical"

-- Location of snips
vim.g.UltiSnipsSnippetDirectories = {'~/.config/nvim/Snips', 'Snips'}
vim.g.UltiSnipsSnippetsDir = "~/.config/nvim/Snips"


vim.g.dashboard_default_executive ='telescope'
nnoremap('<leader>cn','<C-u>DashboardNewFile<CR>')

-- Dasaboard Sessions
nnoremap('<leader>ss','<C-u>SessionSave<CR>')
nnoremap('<leader>sl','<C-u>SessionSave<CR>')

-- For more checkout https://github.com/glepnir/dashboard-nvim/wiki/Ascii-Header-Text
-- vim.g.dashboard_custom_header =[[
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡖⠁⠀⠀⠀⠀⠀⠀⠈⢲⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⣼⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣧⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⣸⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣇⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⢀⣀⣤⣤⣤⣤⣀⡀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣔⢿⡿⠟⠛⠛⠻⢿⡿⣢⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⣀⣤⣶⣾⣿⣿⣿⣷⣤⣀⡀⢀⣀⣤⣾⣿⣿⣿⣷⣶⣤⡀⠀⠀⠀⠀
-- ⠀⠀⢠⣾⣿⡿⠿⠿⠿⣿⣿⣿⣿⡿⠏⠻⢿⣿⣿⣿⣿⠿⠿⠿⢿⣿⣷⡀⠀⠀
-- ⠀⢠⡿⠋⠁⠀⠀⢸⣿⡇⠉⠻⣿⠇⠀⠀⠸⣿⡿⠋⢰⣿⡇⠀⠀⠈⠙⢿⡄⠀
-- ⠀⡿⠁⠀⠀⠀⠀⠘⣿⣷⡀⠀⠰⣿⣶⣶⣿⡎⠀⢀⣾⣿⠇⠀⠀⠀⠀⠈⢿⠀
-- ⠀⡇⠀⠀⠀⠀⠀⠀⠹⣿⣷⣄⠀⣿⣿⣿⣿⠀⣠⣾⣿⠏⠀⠀⠀⠀⠀⠀⢸⠀
-- ⠀⠁⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⢇⣿⣿⣿⣿⡸⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠈⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠐⢤⣀⣀⢀⣀⣠⣴⣿⣿⠿⠋⠙⠿⣿⣿⣦⣄⣀⠀⠀⣀⡠⠂⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠈⠉⠛⠛⠛⠛⠉⠀⠀⠀⠀⠀⠈⠉⠛⠛⠛⠛⠋⠁⠀⠀⠀⠀⠀
-- ]]
--

vim.g.indentLine_fileTypeExclude = { 'dashboard' }

vim.g.indentLine_char_list = {'|', '¦', '┆', '┊'}
vim.g.indentLine_leadingSpaceEnabled = 1


-- Test emote support: should be white skull 💀
