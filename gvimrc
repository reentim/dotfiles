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

  " Terminal vim is experimenting with Selecta, but MacVim continues to use
  "   Command-t
    " let g:CommandTMaxFiles=99000
    " let g:CommandTMatchWindowReverse=1
    " let g:CommandTClearMap='<C-w>'
    " let g:CommandTMaxHeight=10
    " set wildignore+=public/css
    " set wildignore+=public/assets
    " set wildignore+=node_modules
    " set wildignore+=.keep
    " set wildignore+=bower_components
    " set wildignore+=tmp
    " set wildignore+=_site
    " set wildignore+=*.png,*.jpg,*.gif
    " set wildignore+=*.doc,*.docx,*.xls,*.xlsx,*.rtf,*.pdf
    " set wildignore+=*.mp3,*.mp4,*.mkv,*.avi,*.zip,*.rar,*.iso,*.dmg,*.gz
    " nnoremap <leader>t :CommandTFlush<CR>\|:CommandT<CR>
    " nnoremap <leader>gv :CommandTFlush<CR>\|:CommandT app/views<CR>
    " nnoremap <leader>gc :CommandTFlush<CR>\|:CommandT app/controllers<CR>
    " nnoremap <leader>gm :CommandTFlush<CR>\|:CommandT app/models<CR>
    " nnoremap <leader>gh :CommandTFlush<CR>\|:CommandT app/helpers<CR>
    " nnoremap <leader>gl :CommandTFlush<CR>\|:CommandT lib<CR>
    " nnoremap <leader>gp :CommandTFlush<CR>\|:CommandT public<CR>
    " nnoremap <leader>gs :CommandTFlush<CR>\|:CommandT app/assets/stylesheets<CR>
    " nnoremap <leader>gj :CommandTFlush<CR>\|:CommandT app/assets/javascripts<CR>
    " nnoremap <leader>gf :CommandTFlush<CR>\|:CommandT features<CR>

