function! Underline(linechar)
  if g:loaded_commentary == 0
    return
  endif

  let wordline = split(getline('.'))

  if len(wordline) == 0
    return
  endif

  let comment = split(substitute(&commentstring, '%s', '', ''))[0]

  " beginning of line characters that might be comment syntax
  let bol_chars = wordline[0][0:strlen(comment) - 1]

  if bol_chars == comment
    " uncomment current line
    normal gcl
  endif

  " clobber a marker to which to return
  normal ma

  " yank line, paste below
  normal yyp

  " visually select pasted line, replace all with linechar
  execute 'normal v$r' . a:linechar

  if bol_chars == comment
    " comment out underline, re-comment original comment
    normal gck
  endif

  " return to marked position
  normal `a
endfunction

function! SplitHTMLAttrs()
  normal 0dw
  :s/ /\r/g

  " fix indentation, for self closing tags, will indent parent and move
  " cursor...
  normal vat=

  " ...so move it back
  normal `._
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
