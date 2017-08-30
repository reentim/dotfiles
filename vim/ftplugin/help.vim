nnoremap <buffer> <CR> <C-]>
nnoremap <buffer> <BS> <C-T>
nnoremap <buffer> o /'\l\{2,\}'<CR>
nnoremap <buffer> O ?'\l\{2,\}'<CR>
nnoremap <buffer> s :call JumpToNextSubject()<CR>
nnoremap <buffer> S :call JumpToPreviousSubject()<CR>

function! JumpToNextOption()
endfunction

function! JumpToPreviousOption()
endfunction

function! Open()
endfunction

function! GoBack()
endfunction

function! JumpToNextSubject()
  exe "normal! /|.\\{-}|"
endfunction

function! JumpToPreviousSubject()
  exe "normal! ?|.\\{-}|"
endfunction
