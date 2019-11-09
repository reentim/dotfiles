nnoremap <buffer> O :call Option_prev_jump<CR>
nnoremap <buffer> S :call Subject_prev_jump()<CR>
nnoremap <buffer> o :call Option_next_jump()<CR>
nnoremap <buffer> s :call Subject_next_jump()<CR>

function! Option_next_jump()
  execute "normal! /'\l\{2,\}'"
endfunction

function! Option_prev_jump()
  execute "normal! ?'\l\{2,\}'"
endfunction

function! Subject_next_jump()
  execute "normal! /|.\\{-}|"
endfunction

function! Subject_prev_jump()
  execute "normal! ?|.\\{-}|"
endfunction
