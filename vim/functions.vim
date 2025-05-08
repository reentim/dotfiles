if filereadable(expand("~/.vim/trailing_whitespace.vim"))
  source ~/.vim/trailing_whitespace.vim
endif

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

function! SortIndentLevel()
  normal mz
  call SelectIndent()
  execute "normal! :sort\<CR>"
  normal `z
endfunction

function! ResumeCursorPosition()
  " Checks to make sure the last position is valid and not in an event handler.
  " Can be disabled by setting b:noResumeCursorPosition
  if exists('b:noResumeCursorPosition')
    return
  endif

  if line("'\"") > 0 && line("'\"") <= line("$") |
    exe "normal g`\"" |
  endif
endfunction

" Visually select text sharing the same indent level
function! SelectIndent()
  let current_line = line(".")
  let current_indent = indent(current_line)
  let line = current_line

  " Selection top
  while indent(line - 1) == current_indent && strwidth(getline(line - 1)) > 0
    let line = line - 1
  endw
  exe "normal " . line . "G"
  exe "normal V"

  " Selection bottom
  let line = current_line
  while indent(line + 1) == current_indent && strwidth(getline(line + 1)) > 0
    let line = line + 1
  endw
  exe "normal " . line . "G"
endfunction

function! AutocmdCommitMessage()
  let b:noResumeCursorPosition=1
  setlocal textwidth=72 colorcolumn=72 spell
endfunction

function! AutocmdPullRequestMessage()
  let b:noResumeCursorPosition=1
  setlocal textwidth=72 colorcolumn=72 spell
endfunction

function! LineNumbers_toggle()
  let winid = win_getid()
  if &number == 0
    windo set norelativenumber number
  elseif &relativenumber == 0
    windo set relativenumber
  else
    windo set nonumber norelativenumber
  endif
  call win_gotoid(winid)
endfunction

function! SetJournalOptions()
  setlocal textwidth=72 colorcolumn=72 nonumber spell
endfunction

function! RewrapBuffer()
  let lines = line('$')
  let pos = getpos('.')
  call cursor(1, 1)
  keepjumps normal gqG
  call cursor(pos[1] + line('$') - lines, pos[2])
endfunction

function! CdToProjectRoot()
  if type(FugitiveWorkTree()) == 1
    exec "lcd " . FugitiveWorkTree()
    return 1
  endif
  return 0
endfunction
