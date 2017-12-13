function! IsCommentLine()
  let wordline = split(getline('.'))
  if len(wordline) == 0
    return
  endif
  let comment = split(substitute(&commentstring, '%s', '', ''))[0]
  let bol_chars = wordline[0][0:strlen(comment) - 1]
  return bol_chars == comment
endfunction

function! Underline(linechar)
  if g:loaded_commentary == 0
    return
  endif
  if IsCommentLine()
    let comment_line = 1
  else
    let comment_line = 0
  endif
  if comment_line
    " uncomment current line
    normal gcl
  endif
  " clobber a marker to which to return
  normal ma
  " yank line, paste below
  normal yyp
  " visually select pasted line, replace all with linechar
  execute 'normal v$r' . a:linechar
  if comment_line
    " comment out underline, re-comment original comment
    normal gck
  endif
  " return to marked position
  normal `a
endfunction

function! FullUnderline(linechar)
  if g:loaded_commentary == 0
    return
  endif
  if &textwidth
    let width = &textwidth
  else
    let width = 80
  endif
  normal ma
  normal yypD
  execute 'normal ' . width . 'a' . a:linechar
  normal gcl
  execute 'normal ' . width . '|lD'
  normal `a
endfunction

function! SplitLine()
  normal ma
  let line = getline('.')
  if line =~ "<%" && &filetype == "eruby"
    :s/\((\)/\1\r
    " :s/\(,\)\(\s:\|\s"\)/\1\r\2/g
    :s/\(,\)/\1\r/g
    :s/\(\s\?)\s%>\)/\r\1/g
  elseif line =~ "/>"
    :s/\(\s\w\+\(\-\?\)\w\+=\)/\r\1/g
    :s/\(\s\/>\)/\r\1/g
  elseif &filetype == "ruby"
    :s/\./\r./g
    " :s/,/,\r/g
  else
    :s/\(\s\w\+\(\-\?\)\w\+=\)/\r\1/g
  endif
  normal $=`a
endfunction

function! TrimWhiteSpace()
  %s/\s\+$//e
  normal ``
endfunction

function! SetWatch()
  :!watch '%:p:h' > /dev/null 2>&1 &
  let g:watching = 1
endfunction

function! RemoveWatch()
  if g:watching == 1
    :!pkill ruby /usr/local/bin/watch
  endif
endfunction

function! NextIndent(exclusive, fwd, lowerlevel, skipblanks)
  " http://vim.wikia.com/wiki/Move_to_next/previous_line_with_same_indentation
  " ---------------------------------------------------------------------------
  " Jump to the next or previous line that has the same level or a lower
  " level of indentation than the current line.
  "
  " exclusive (bool): true: Motion is exclusive
  " false: Motion is inclusive
  " fwd (bool): true: Go to next line
  " false: Go to previous line
  " lowerlevel (bool): true: Go to line with lower indentation level
  " false: Go to line with the same indentation level
  " skipblanks (bool): true: Skip blank lines
  " false: Don't skip blank lines

  let line = line('.')
  let column = col('.')
  let lastline = line('$')
  let indent = indent(line)
  let stepvalue = a:fwd ? 1 : -1
  while (line > 0 && line <= lastline)
    let line = line + stepvalue
    if ( ! a:lowerlevel && indent(line) == indent ||
          \ a:lowerlevel && indent(line) < indent)
      if (! a:skipblanks || strlen(getline(line)) > 0)
        if (a:exclusive)
          let line = line - stepvalue
        endif
        exe line
        exe "normal " column . "|"
        return
      endif
    endif
  endwhile
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

function! VisibleBuffers()
  return tabpagebuflist(tabpagenr())
endfunction

function! HiddenBuffers()
  let hidden_buffers = []

  for b in range(1, bufnr('$'))
    if buflisted(b) && index(VisibleBuffers(), b) == -1
      call add(hidden_buffers, b)
    endif
  endfor

  return hidden_buffers
endfunction

" :bdelete also closes the current window; this function closes the buffer while
" leaving the window intact.
function! CloseBuffer()
    enew
    split #
    bdelete
    bnext
endfunction

function! RunFile()
  if &ft == "bash" || &ft == "sh"
    !clear && time bash %:p
  elseif &ft == "ruby"
    if expand('%t') == "Gemfile"
      !clear && time bundle
    else
      !clear && time ruby %:p
    endif
  elseif &ft == "python"
    !clear && time python %:p
  elseif &ft == "javascript"
    !clear && time node %:p
  elseif &ft == "vim"
    source %:p
  elseif &ft
    execute "echo \"Don't know how to run" . &ft . " files.\""
  else
    echo "Don't know what sort of file this is."
  endif
endfunction

function! RunCurrentTest(context)
  if &filetype == "javascript" || &filetype == "javascript.jsx"
    exe ":!clear && time $(yarn bin)/jest " . expand('%')
    return
  endif

  if InTestFile()
    call SetTestFile()
    if a:context == 'at_line'
      call SetTestFileLine()
    endif
  endif
  if a:context == 'at_line'
    let line_options = ":" . TestFileLine()
  else
    let line_options = ""
  endif

  let test_command = " rspec --color --tty -f doc "
  let test_string = TestPrefix() . l:test_command . TestFile() . l:line_options

  if TmuxTestPaneRunning()
    exe ":silent !tmux send-keys -t " . g:tmux_test_pane_number  . " 'clear && time " . l:test_string . "' C-m"
    redraw!
  elseif TmuxTestWindowRunning()
    exe ":silent !tmux send-keys -t spec:spec 'clear && time " . l:test_string . "' C-m"
    redraw!
  else
    exe ":!clear && time " . l:test_string
  endif
endfunction

function! TestPrefix()
  if glob(".zeus.sock") != ""
    return "zeus"
  else
    return ""
  endif
endfunction

function! TmuxTestWindowRunning()
  call system("tmux send-keys -t spec:spec")
  let return_code = v:shell_error

  " 0 is falsy in VimScript
  if return_code == 0
    return 1
  else
    return 0
  endif
endfunction

function! TmuxTestPaneRunning()
  if g:tmux_test_pane_enabled == 1
    call system("[[ $(printf %d $(tmux list-panes | wc -l)) > 1 ]]")
    let multiple_splits = v:shell_error

    if multiple_splits == 0
      return 1
    else
      return 0
    endif
  endif
endfunction

function! InTestFile()
  let pattern = '\(.feature\|_spec.rb\|_test.rb\|test.js\)$'
  return match(expand("%"), pattern) != -1
endfunction

function! SetTestFile()
  let g:test_file=@%
endfunction

function! SetTestFileLine()
  let g:test_file_line = line(".")
endfunction

function! TestFile()
  if exists("g:test_file")
    return g:test_file
  else
    return expand('%')
  endif
endfunction

function! TestFileLine()
  return g:test_file_line
endfunction

function! GetVisualSelection()
  " http://stackoverflow.com/a/6271254
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return lines
endfunction

function! CopyToHost()
  let selection = GetVisualSelection()
  call writefile(selection, $HOME . "/.vim-clipboard.txt")
  call system("cat ~/.vim-clipboard.txt | ssh client 'pbcopy'")
  echom 'Copied to clipboard!'
endfunction

function! ItermProfile()
  if filereadable("/tmp/" . $ITERM_SESSION_ID . "-iterm_profile")
    return readfile("/tmp/" . $ITERM_SESSION_ID . "-iterm_profile")[0]
  else
    return $ITERM_PROFILE
  endif
endfunction

function! DeleteInactiveBufs()
  "From tabpagebuflist() help, get a list of all buffers in all tabs
  let tablist = []
  for i in range(tabpagenr('$'))
    call extend(tablist, tabpagebuflist(i + 1))
  endfor

  "Below originally inspired by Hara Krishna Dara and Keith Roberts
  "http://tech.groups.yahoo.com/group/vim/message/56425
  let nWipeouts = 0
  for i in range(1, bufnr('$'))
    if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1 && buflisted(i)
      "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs AND the buffer is listed (don't blow away Command-T, ControlP, etc)
      silent exec 'bwipeout' i
      let nWipeouts = nWipeouts + 1
    endif
  endfor
  echomsg nWipeouts . ' buffer(s) wiped out'
endfunction

function! PromoteVariableToMethod()
  execute "normal ddmb/defkodefjokkp==kdddt=?defA pxj_dw`b"
endfunction

function! InteractiveRebaseFixup()
  while search('\vpick [0-9a-f]{7} fix [0-9a-f]{7}$')
    normal $*NddNp
    normal cwf
  endwhile
endfunction

" Creates a find command ignoring paths and files set in wildignore
function! FindWithWildignore(path)
  let excluding=""
  for entry in split(&wildignore,",")
    let excluding.= (match(entry,'*/*') ? " ! -ipath \'" . a:path . "/" : " ! -iname \'") . entry . "\' "
  endfor
  return "find " . a:path . "/* -type f \\\( " . excluding . " \\\)"
endfunction

function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    let selection = system(a:choice_command . " | selecta " . a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

function! SelectaFile(path)
  call SelectaCommand(FindWithWildignore(a:path), "", ":e")
endfunction

function! SelectaGitFile(path)
  call SelectaCommand("git ls-files", "", ":e")
endfunction

"Fuzzy select
function! SelectaIdentifier()
  " Yank the word under the cursor into the z register
  normal "zyiw
  " Fuzzy match files in the current directory, starting with the word under
  " the cursor
  call SelectaCommand("find * -type f", "-s " . @z, ":e")
endfunction
nnoremap <c-g> :call SelectaIdentifier()<cr>

function! SelectaBuffer()
  let bufnrs = filter(range(1, bufnr("$")), 'buflisted(v:val)')
  let buffers = map(bufnrs, 'bufname(v:val)')
  call SelectaCommand('echo "' . join(buffers, "\n") . '"', "", ":b")
endfunction

function! ShouldToExpect()
  %s/\(\S\+\).should\(\s\+\)==\s*\(.\+\)/expect(\1).to\2eq(\3)/
endfunction

function! Debounce(command)
  execute a:command
endfunction

function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction

function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.e\?rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction

function! CdToProjectRoot()
  call system("git rev-parse --git-dir")

  if v:shell_error != 0
    return
  endif

  exec 'cd ' . expand('%:p:h')
  exec 'cd ' . system("git rev-parse --show-cdup")
endfunction
