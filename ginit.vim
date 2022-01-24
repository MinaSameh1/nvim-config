" Fix key mapping issues for GUI
inoremap <silent> <S-Insert>  <C-R>+
cnoremap <S-Insert> <C-R>+
nnoremap <silent> <C-6> <C-^>

" Increases the font size with `amount`
function! Zoom(amount) abort
  call ZoomSet(matchstr(&guifont, '\d\+$') + a:amount)
endfunc

" Sets the font size to `font_size`
function ZoomSet(font_size) abort
  let &guifont = substitute(&guifont, '\d\+$', a:font_size, '')
endfunc

noremap <silent> <C-+> :call Zoom(v:count1)<CR>
noremap <silent> <C--> :call Zoom(-v:count1)<CR>
noremap <silent> <C-0> :call ZoomSet(11)<CR>

" To check if neovim-qt is running, use `exists('g:GuiLoaded')`,
" see https://github.com/equalsraf/neovim-qt/issues/219
if exists('g:GuiLoaded')
  " call GuiWindowMaximized(1)
  GuiTabline 0
  GuiPopupmenu 0
  GuiLinespace 2
  "GuiFont! Inconsolata\ Nerd\ Font:h13:l
  "GuiFont! iMWritingMonoS\ Nerd\ Font:h12
  GuiFont! Hack:h9
  
  " Right Click Context Menu (Copy-Cut-Paste)
  nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
  inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
  xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
  snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR
  nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
  nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>" FVimToggleFullScreen
endif

if exists('g:fvim_loaded')
  set guifont=iMWritingMonoS\ Nerd\ Font:h14:1
  set termguicolors
  "set guifont=Inconsolata\ Nerd\ Font:h13
  "set guifont=iMWritingMonoS\ Nerd\ Font:h14:1
  " Cursor tweaks
  "FVimCursorSmoothMove v:true
  FVimCursorSmoothBlink v:true

  " Ctrl-ScrollWheel for zooming in/out
  nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
  nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>" FVimToggleFullScreen
  nnoremap <C-CR> :FVimToggleFullScreen<CR>
  " Background composition, can be 'none', 'blur' or 'acrylic'
  FVimBackgroundComposition 'blur'
  FVimBackgroundOpacity 0.8
  FVimBackgroundAltOpacity 1.0

  " Title bar tweaks (themed with colorscheme)
  FVimCustomTitleBar v:true

  " Debug UI overlay
  FVimDrawFPS v:false
  " Font debugging -- draw bounds around each glyph
  FVimFontDrawBounds v:false

  " Font tweaks
  FVimFontAntialias v:true
  FVimFontAutohint v:true
  FVimFontHintLevel 'full'
  FVimFontSubpixel v:true
  FVimFontLigature v:true
  " can be 'default', '14.0', '-1.0' etc.
  FVimFontLineHeight '+1'

  " Try to snap the fonts to the pixels, reduces blur
  " in some situations (e.g. 100% DPI).
  FVimFontAutoSnap v:true

  " Font weight tuning, possible values are 100..900
  FVimFontNormalWeight 100
  FVimFontBoldWeight 700

  FVimUIPopupMenu v:true
endif

if exists('neovide')
  set guifont=iMWritingMonoS\ Nerd\ Font:h12
  "set guifont=Consolata:h12
  let g:neovide_cursor_vfx_mode = "railgun"
  " Right Click Context Menu (Copy-Cut-Paste)
  nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
  inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
  xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
  snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR
  nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
  nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>" FVimToggleFullScreen
endif
