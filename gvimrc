" Appearance
" ==============================================================================
  set guifont=SF\ Mono
  colorscheme solarized
  set background=light
  let g:indent_guides_auto_colors = 1
  set colorcolumn=80
  set ruler

" Disable window chrome
" ==============================================================================
  set guioptions-=T " don't show toolbar
  set guioptions-=r " don't show scrollbars
  set guioptions-=l " don't show scrollbars
  set guioptions-=R " don't show scrollbars
  set guioptions-=L " don't show scrollbars

" Behaviour
" ==============================================================================
  autocmd BufLeave,FocusLost * silent! wall
  set vb " use (nonexistent) visual bell instead of audio
  nnoremap <leader>eg :e $MYGVIMRC<cr>

  " Selecta doesn't work :(
  nnoremap <leader>t :CtrlP<CR>
