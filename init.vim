" When started as "evim", bail out.
if v:progname =~? "evim"
  finish
endif

syntax on

set guicursor=
set noshowmatch
set relativenumber
" Shows a + on the cursor
" set cursorcolumn
" set cursorline
" search stuff, remove no for highlight
set nohlsearch
set incsearch
set ignorecase
set smartcase
set hidden
set noerrorbells
set tabstop=2 softtabstop=4
set shiftwidth=2
" change tab to space
set expandtab
set smartindent
set nowrap
set noswapfile
" Set 80 column border 
set cc=80
" Some Servers have issues with backup files
set nobackup
set nowritebackup
" Undodir to keep undos from files.
set undodir=~/.config/nvim/undodir
set undofile
set undolevels=5000
set termguicolors
"set termsize=10x0 
set scrolloff=8
set noshowmode
set ttyfast
set mouse=a
set smarttab
set ruler
" Allow autocomplete on tab in command line
set wildmenu
" Reload the file if it changed outside of vim
set autoread
" Relative Number and number
set rnu nu
" Treat all formats as decimals (instead of like octal 007)
set nrformats=
" use utf8
set encoding=UTF-8
set fileencoding=UTF-8
set fileencodings=UTF-8
" Similair to bash
set wildmode=longest,list
" File indentation
filetype plugin indent on
set smartindent
"Autosave folds
"autocmd BufWinLeave *.* mkview
"autocmd BufWinEnter *.* silent loadview
" Auto indent methods CUZ OF REACTTTT
setlocal indentkeys+=0
" 
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300


" for tmux
if &term =~ 'screen*'
    set ttymouse=xterm2
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!
  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" open new buffer
nmap <leader>T :enew<cr>
" Move to the next buffer
nmap <leader>l :bnext<CR>
" Move to the previous buffer
nmap <leader>h :bprevious<CR>
" Close the current buffer and move to the previous one
nmap <leader>bq :bp <BAR> bd #<CR>
" Show all open buffers and their status
nmap <leader>bl :ls<CR>
" Open terminal below all splits
cabbrev bterm bo term
" Open terminal
nmap <leader>` :term<CR>

"Map F5 for compiling except Tex files as that button is already mapped
autocmd BufNewFile,BufRead *.hla map <F5> :!hla % && ./%:r<CR>
autocmd Filetype c map <F5> :!gcc % && ./a.out <CR>
autocmd Filetype c map <F6> :!gcc -lncurses -Wall -Wextra % && ./a.out <CR>
autocmd Filetype java map <F5> :!java % <CR>
autocmd Filetype python map <F5> :!python % <CR>
autocmd Filetype tex map <F9> :!pdflatex % <CR>
autocmd Filetype cpp map <F5> :!g++ % && ./a.out <CR>
autocmd Filetype rmd map <F5> :!R -e "require(rmarkdown);render('%')"<CR><CR>
autocmd Filetype markdown map <F5> :!pandoc % -o %:r.pdf<CR>
autocmd Filetype sh map <F5> :!./% <CR>
autocmd Filetype nroff map <F5> :!groff % -m ms -Tpdf
autocmd Filetype html map <F6> :!firefox % > /dev/null 2>&1 & <CR> | map <F5> :!surf % > /dev/null 2>&1 & <CR>
autocmd Filetype php map <F5> :!php %<CR>
autocmd Filetype c,cpp
			\ nmap <Leader>{ <Insert>{<CR>`<CR>}<UP><Right><Del><Esc> |
			\ packadd termdebug |
			\ imap /*          /* */<Left><Left><Left> |
			\ imap #if0        #if 0<CR><CR>#endif<UP>

autocmd Filetype ocaml map <F5> :!ocamlc % -g -o %:r && ./%:r <CR>
" Prettier
nnoremap <leader>fF :!prettier --write %<CR>
" Additional Mapping
" Open current name but with pdf, useful for latex or markdown :)
map <F6> :!zathura %:r.pdf > /dev/null 2>&1 & <CR>
"Spell check toggle
map <F10> :setlocal spell! <CR>
"Save file
map <Leader>w :w<CR>
" stop highlighting
map <silent> <Leader>/ :noh <CR>

" open splits more naturally
set splitbelow
set splitright

" To make saving write protected files easier, make sure to set SUDO_ASKPASS!
com -bar W exe 'w !sudo tee >/dev/null %:p:S' | setl nomod

" Edit config files
cmap c!! e ~/.config/nvim/init.vim
cmap cg!! e ~/.config/nvim/ginit.vim

" set background to dark, it can be light
set background=dark

" Was good till i started using python and markdown both of which use spaces
"fun! TrimWhitespace()
"    let l:save = winsaveview()
"    keeppatterns %s/\s\+$//e
"    call winrestview(l:save)
"endfun
"autocmd BufWritePre * :call TrimWhitespace()

" enable modelines
set modeline
set modelines=5

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

" TODO: Move everything to lua cuz why not
" TODO: Look into other git clients than fugitive, its super helpful tho
" Plugins and their configs

luafile ~/.config/nvim/config/plugins.lua
luafile ~/.config/nvim/config/lualine.lua
luafile ~/.config/nvim/config/NeovimLSP.lua
luafile ~/.config/nvim/config/cmp.lua
luafile ~/.config/nvim/config/dap.lua
luafile ~/.config/nvim/config/toggleterm.lua
luafile ~/.config/nvim/config/nvimtree.lua
luafile ~/.config/nvim/config/comments.lua
luafile ~/.config/nvim/config/gitsigns.lua
luafile ~/.config/nvim/config/treesitter.lua
luafile ~/.config/nvim/config/telescope.lua
luafile ~/.config/nvim/config/autopairs.lua
"source ~/.config/nvim/config/coc.vim -- Replaced with builtin lsp
"source ~/.config/nvim/config/ale.vim -- Replaced 
"source ~/.config/nvim/config/neomake.vim
"source ~/.config/nvim/config/ocaml.vim
source ~/.config/nvim/config/fugitive.vim 

" Colorscheme
colorscheme dracula

" open our tagbar
nmap <F3> :TagbarToggle<CR>

" nnoremap <silent><leader>ca :Lspsaga code_action<CR>
" vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>
" GitGutter to show both the numbers and signs
"set signcolumn=yes

" These commands will navigate through buffers in order regardless of which mode you are using
" e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
nnoremap <silent>[b :BufferLineCycleNext<CR>
nnoremap <silent>]b :BufferLineCyclePrev<CR>

" These commands will move the current buffer backwards or forwards in the bufferline
nnoremap <silent>[B :BufferLineMoveNext<CR>
nnoremap <silent>]B :BufferLineMovePrev<CR>

" These commands will sort buffers by directory, language, or a custom criteria
nnoremap <silent>be :BufferLineSortByExtension<CR>
nnoremap <silent>bd :BufferLineSortByDirectory<CR>

"" Settings for Easy Align "
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

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

"" UtilSnipet 
" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" If you want :UltiSnipsEdit to split your window.
"let g:UltiSnipsEditSplit="vertical"
" Location of snips
let g:UltiSnipsSnippetDirectories = ['~/.config/nvim/Snips', 'Snips']
let g:UltiSnipsSnippetsDir="~/.config/nvim/Snips"


let g:dashboard_default_executive ='telescope'
nmap <Leader>cn :<C-u>DashboardNewFile<CR>


" Dasaboard Sessions
nnoremap <Leader>ss :<C-u>SessionSave<CR>
nnoremap <Leader>sl :<C-u>SessionLoad<CR>


" Use K to show documentation in preview window
" nnoremap <silent> K :call <SID>show_documentation()<CR>

" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   else
"     call CocAction('doHover')
"   endif
" endfunction

let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_leadingSpaceEnabled=1


"  -- Test emote support: should be white skull 💀
