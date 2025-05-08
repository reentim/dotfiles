augroup vimrc_autosave
  autocmd!

  if exists("g:autosave")
    autocmd InsertLeave,TextChanged * silent! update
  endif
augroup END
