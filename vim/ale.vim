augroup Ale_events
  autocmd!

  autocmd User ALELintPre call Ale_make_room()
  autocmd User ALELintPost call Ale_make_room()
  autocmd User ALEJobStarted call Ale_make_room()
  autocmd User ALEFixPre call Ale_make_room()
  autocmd User ALEFixPost call Ale_make_room()
augroup END

function! Ale_make_room()
  " Eliminate buffer redraw when ALE shows up by turning off line numbers and
  " abusing foldcolumn to occupy the delta
  if empty(ale#engine#GetLoclist(bufnr('$')))
    set nu
    set foldcolumn=0
  else
    set nonu
    set foldcolumn=2
  endif
endfunction
