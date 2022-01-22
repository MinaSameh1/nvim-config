let g:tex_flavor  = 'latex'
let g:tex_conceal = ''


let g:vimtex_latexmk_continuous = 1
" SumatraPDF for windows, zathura for linux :)
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_general_viewer = 'zathura'

" VimTeX uses latexmk as the default compiler backend. If you use it, which is
" strongly recommended, you probably don't need to configure anything. If you
" want another compiler backend, you can change it as follows. The list of
" supported backends and further explanation is provided in the documentation,
" see ":help vimtex-compiler".
let g:vimtex_compiler_method = 'latexrun'

" Most VimTeX mappings rely on localleader and this can be changed with the
" following line. The default is usually fine and is the symbol "\".
let maplocalleader = ","
