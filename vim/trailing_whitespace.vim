function! TrailingWhitespace_highlight()
  highlight TrailingWhitespace ctermbg=red guibg=red
endfunction

function! TrailingWhitespace_trim()
  %s/\s\+$//e
  normal ``
endfunction

augroup TrailingWhitespace
  autocmd!

  call TrailingWhitespace_highlight()
  autocmd BufEnter * match TrailingWhitespace /\s\+$/
  autocmd InsertEnter * match TrailingWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match TrailingWhitespace /\s\+$/
  autocmd BufWinLeave * call clearmatches()
augroup END
