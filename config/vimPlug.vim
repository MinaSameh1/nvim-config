""" PLUGGGINSSSS  """
call plug#begin()
" LUAA
Plug 'nvim-lua/plenary.nvim'
" Comments, NerdCommenter is more powerfull but i dont need that much power
"Plug 'preservim/nerdcommenter', { "do", ":source
"~/.config/nvim/config/nerdcommenter.vim" }
Plug 'tpope/vim-commentary' " Use gc to toggle commented stuff :) 
" Dashboard
Plug 'glepnir/dashboard-nvim'
" Pairs and close etc 
Plug 'jiangmiao/auto-pairs' "Its actually pretty cool and can surrond stuff too!
Plug 'tpope/vim-surround' " use ysiw for example i guess 
" Repeats plugins with . as well
Plug 'tpope/vim-repeat'
" Status line
Plug 'nvim-lualine/lualine.nvim'
"Plug 'feline-nvim/feline.nvim'
" Smooth scrolling
Plug 'karb94/neoscroll.nvim'
" Terminal
Plug 'akinsho/toggleterm.nvim'
" Folders and stuff
" Plug 'preservim/nerdtree'
Plug 'kyazdani42/nvim-tree.lua'
" Aligns things easly using gaip=
Plug 'junegunn/vim-easy-align'
" Vim MultiCurosr, use cgn instead :)
"Plug 'mg979/vim-visual-multi', {'branch': 'master'}
" Emmeet for html
Plug 'mattn/emmet-vim'
" Bar
Plug 'akinsho/bufferline.nvim'
" TAG BAR
Plug 'preservim/tagbar'
" Syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
" Linting among other things
" LSP 
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
" AutoCompletetion
Plug 'hrsh7th/nvim-cmp' 
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
" Big Boy really powerfull, I recommend using COC for out the box experince
" and good keybindings :)
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
" ALE was the jam back in my vim days :)
"Plug 'dense-analysis/ale'
" tried, its good i will stick with other things for now its not my cup of tea
"Plug 'neomake/neomake'
" Debugger
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
"Plug 'jbyuki/one-small-step-for-vimkind' " For nvim lua 
Plug 'nvim-telescope/telescope-dap.nvim'
" Meh java xd, cant get it work for some reason ah well
"Plug 'mfussenegger/nvim-jdtls', { 'do':'source ~/.config/nvim/config/jdtls.lua'} 
Plug 'mfussenegger/nvim-dap-python'
" Git integration
"Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'
"Plug 'airblade/vim-gitgutter'
" Latex stuff i guess
Plug 'lervag/vimtex'
" Search, and fuzzy stuff, far for replace
Plug 'brooth/far.vim'
"Plug 'ctrlpvim/ctrlp.vim' " Does the same thing as telescope
"Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }
Plug 'nvim-telescope/telescope.nvim'
" Syntax and languages
Plug 'sheerun/vim-polyglot'
" Plug 'pangloss/vim-javascript'
" Plug 'leafgarland/typescript-vim'
" Shows tabs and spaces
Plug 'yggdroot/indentline'
" heighlights Colors with their color xd
Plug 'norcalli/nvim-colorizer.lua'
" Goodlooking lsp gui
Plug 'glepnir/lspsaga.nvim' 
" pretty messages
Plug 'folke/trouble.nvim' 
" Snippets
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'honza/vim-snippets'
" Icons
Plug 'kyazdani42/nvim-web-devicons'
"Plug 'ryanoasis/vim-devicons'
" Themes
Plug 'rktjmp/lush.nvim' " used to create colorschemes
Plug 'nanotech/jellybeans.vim' , {'as': 'jellybeans'}
Plug 'ellisonleao/gruvbox.nvim'
Plug 'dracula/vim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'shaunsingh/nord.nvim'
" Colors
Plug 'tjdevries/colorbuddy.vim'
Plug 'overcache/NeoSolarized'
call plug#end()

" Colorscheme
colorscheme dracula

" open nerdtree
nmap <F2> <Cmd>NvimTreeToggle<CR>
" open our tagbar
nmap <F3> :TagbarToggle<CR>

lua << END

require'neoscroll'.setup()
require'colorizer'.setup()

-- Status Line Feline
-- require('feline').setup()


-- Git Signs start
-- require('gitsigns').setup()

require'nvim-web-devicons'.setup()

require'nvim-tree'.setup {}

require('telescope').setup()

require("bufferline").setup()

require('nvim-treesitter').setup()

require("colorbuddy").setup()

require'toggleterm'.setup {
  open_mapping = [[<c-\>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_terminals = true,
}

END
