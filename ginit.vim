"" Mappings for all of them
" Fix key mapping issues for GUI
inoremap <silent> <S-Insert>  <C-R>+
cnoremap <S-Insert> <C-R>+
nnoremap <silent> <C-6> <C-^>


" To check if neovim-qt is running, use `exists('g:GuiLoaded')`,
" see https://github.com/equalsraf/neovim-qt/issues/219
if exists('g:GuiLoaded')
  " call GuiWindowMaximized(1)
  GuiTabline 0
  GuiPopupmenu 0
  GuiLinespace 2
  " GuiFont! Inconsolata\ Nerd\ Font:h13:l
  " GuiFont! iMWritingMonoS\ Nerd\ Font:h12
  " GuiFont! FiraCode NF:h9
  " GuiFont! Iosevka\ Light:h10
  GuiFont! Fantasque\ Sans\ Mono:h16
  
  " Right Click Context Menu (Copy-Cut-Paste)
  nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
  inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
  xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
  snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR

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
  nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
  nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
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
endif

if exists('neovide')
  " let g:neovide_transparency = 0.8
  " Increases the font size with `amount`
  function! Zoom(amount) abort
    call ZoomSet(matchstr(&guifont, '\d\+$') + a:amount)
  endfunc

  " Sets the font size to `font_size`
  function ZoomSet(font_size) abort
    let &guifont = substitute(&guifont, '\d\+$', a:font_size, '')
  endfunc

  "" Fonts that I normally use, I like to switch things up
  " set guifont=Hack\ Nerd\ Font:h11
  " set guifont=Inconsolata Nerd Font:h12
  " set guifont=FiraCode\ Nerd\ Font:h10 "Font that will be used in GUI vim
  set guifont=Iosevka\ Light:h16


   " effects (sonicboom, ripple, railgun, torepedo)
  let g:neovide_cursor_vfx_mode = "railgun"
  let g:neovide_cursor_antialiasing=v:true " Cursor antialiasing
  let g:neovide_refresh_rate=120  " Refresh rate
  
  " Always redraw
  " let g:neovide_no_idle=v:true

  noremap <silent> <C-+> :call Zoom(v:count1)<CR>
  noremap <silent> <C--> :call Zoom(-v:count1)<CR>
  noremap <silent> <C-0> :call ZoomSet(16)<CR>
  nnoremap <silent> <C-ScrollWheelUp> :call Zoom(v:count1)<CR>
  nnoremap <silent> <C-ScrollWheelDown> :call Zoom(-v:count1)-<CR>

  " Toggles fullscreen
  nnoremap <leader>GF :call NeovideToggleFullScreen()<CR>
  function NeovideToggleFullScreen()
    if g:neovide_fullscreen 
      let g:neovide_fullscreen=v:false
    else 
      let g:neovide_fullscreen=v:true
    endif
  endfunc

  let g:transparent_enabled = v:true
endif
