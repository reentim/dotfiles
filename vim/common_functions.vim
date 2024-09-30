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
  " Comments should be fixed to the line they follow
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

" Visually select contiguous block of text sharing the same indent level
function! SelectIndent()
  let cur_line = line(".")
  let cur_ind = indent(cur_line)
  let line = cur_line

  " Selection top
  while indent(line - 1) == cur_ind && strwidth(getline(line - 1)) > 0
    let line = line - 1
  endw
  exe "normal " . line . "G"
  exe "normal V"

  " Selection bottom
  let line = cur_line
  while indent(line + 1) == cur_ind && strwidth(getline(line + 1)) > 0
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
  if &nu
    windo set nonu
  else
    windo set nu
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

function! GitTopLevelDir(...)
  let dir = get(a:000, 0, getcwd())

  let git_dir = System("cd " . l:dir . " && git rev-parse --show-toplevel 2>/dev/null")
  return l:git_dir != "" ? l:git_dir : 0
endfunction

function! CdToProjectRoot()
  if &ft =~ '\(fugitiveblame\|git\|help\)'
    return 0
  endif

  let file_git_dir = GitTopLevelDir(expand("%:h"))
  if type(l:file_git_dir) == 1
    exec "lcd " . l:file_git_dir
    return 1
  endif
  return 0
endfunction

function! System(command)
  " strip away the last byte of output
  return system(a:command)[:-2]
endfunction

function! Profile_get()
  return System("current-profile")
endfunction
