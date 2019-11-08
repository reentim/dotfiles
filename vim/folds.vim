function! Folds_autocmd_set()
  augroup Folds
    autocmd!

    autocmd CursorMoved * call Folds_update()
  augroup END
endfunction

function! Folds_enable()
  let g:Folds_enabled = 1
  call Folds_autocmd_set()
endfunction

function! Folds_disable()
  let g:Folds_eanbled = 0
  autocmd! Folds
endfunction

function! Folds_enabled()
  return get(g:, "Folds_enabled", 0)
endfunction

function! Folds_update()
  if !Folds_enabled()
    return
  endif
  " Hacky: zJ zK zj zk set this before cursormove, to preserve their behaviour
  " this might be more contained if I could read normal mode history?
  if get(g:, "Folds_updates_temp_disabled", 0) == 1
    let g:Folds_updates_temp_disabled = 0
    return
  endif
  let line = line(".")
  let last_folded = get(g:, "Folds_updated_line", -1)
  if l:last_folded != l:line
    normal zx
    if foldlevel(l:line) > 0
      normal zO
    endif
    let g:Folds_updated_line = l:line
  endif
endfunction

function! Folds_closed_jump(direction)
  let g:Folds_updates_temp_disabled = 1

  " https://stackoverflow.com/a/9407015
  let cmd = 'norm!z' . a:direction
  let view = winsaveview()
  let [l0, l, open] = [0, view.lnum, 1]
  while l != l0 && open
      exe cmd
      let [l0, l] = [l, line('.')]
      let open = foldclosed(l) < 0
  endwhile
  if open
      call winrestview(view)
  endif
endfunction

function! Folds_open_jump(direction)
  " TODO: this should run zj zk, but how to run them without their mapping to
  " this function?
  call Folds_closed_jump(a:direction)
endfunction
