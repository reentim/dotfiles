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

function! SplitHTMLAttrs()
  normal ma
  let line = getline('.')
  if line =~ "<%" && &filetype == "eruby"
    :s/\((\)/\1\r
    " :s/\(,\)\(\s:\|\s"\)/\1\r\2/g
    :s/\(,\)/\1\r/g
    :s/\(\s\?)\s%>\)/\r\1/g
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

function! CloseBuffer()
  if len(HiddenBuffers()) > 0
    execute "buffer" . HiddenBuffers()[0]
  else
    enew
  endif

  if buffer_name('%') != ""
    split #
    bdelete
  endif
endfunction

function! RunFile()
  if &ft == "bash" || &ft == "sh"
    !clear && time bash %:p
  elseif &ft == "ruby"
    !clear && time ruby %:p
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

  if TmuxTestWindowRunning()
    echo 'yes'
  else
    echo 'no'
  endif

  if TmuxTestWindowRunning()
    exe ":silent !tmux send-keys -t spec:spec 'clear && time " . TestPrefix() . " rspec --color --tty -f doc " . TestFile() . line_options . "' C-m"
    redraw!
  else
    exe ":!clear && time " . TestPrefix() . " rspec --color --tty -f doc " . TestFile() . line_options
  endif
endfunction

function! TestPrefix()
  if glob(".zeus.sock") != ""
    return "zeus"
  else
    return "bundle exec"
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

function! InTestFile()
  return match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
endfunction

function! SetTestFile()
  let g:test_file=@%
endfunction

function! SetTestFileLine()
  let g:test_file_line = line(".")
endfunction

function! TestFile()
  return g:test_file
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
  if filereadable($HOME . "/.iterm_profile")
    return readfile($HOME . "/.iterm_profile")[0]
  else
    return $ITERM_PROFILE
  endif
endfunction
