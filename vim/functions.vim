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
    :s/>/\r>/g
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
  " exclusive (bool):  true: motion is exclusive; false: motion is inclusive
  " fwd (bool):        true: go to next line; false: go to previous line
  " lowerlevel (bool): true: go to line with lower level; false: go to line with the same level
  " skipblanks (bool): true: skip blank lines; false: don't skip blank lines

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
    " bnext
endfunction

function! RunFile()
  if &ft == "bash" || &ft == "sh"
    call Shell('bash "' . expand('%:p') . '"')
  elseif &ft == "ruby"
    if expand('%:t') == "Gemfile"
      call Shell('bundle')
    elseif expand('%:h') == "db/migrate"
      call RunRailsMigration(RailsMigrationVersion(expand('%:t')))
    elseif expand('%:t') == 'routes.rb'
      call Shell('rails routes')
    else
      call Shell('ruby ' . expand('%'))
    endif
  elseif &ft == "python"
    call Shell('python ' . expand('%:p'))
  elseif &ft == "javascript"
    call Shell('node ' . expand('%:p'))
  elseif &ft == "vim"
    source %:p
  elseif &ft == "c"
    call Shell('gcc ' . expand('%') . ' -o ' . expand('%:r') . ' && clear && ./' . expand('%:r'))
  elseif &ft
    execute "echo \"Don't know how to run" . &ft . " files.\""
  else
    echo "Don't know what sort of file this is."
  endif
endfunction

function! RailsMigrationVersion(filename)
  return split(a:filename, "_")[0]
endfunction

function! ShouldSendOutputToTmux()
  return ShellOK('tmux-recipient') && $TMUX != ''
endfunction

function! RailsMigrationStatus(version)
  if ShellOK('test -f db/structure.sql')
    " structure.sql contains a list of migrated versions
    if ShellOK("grep " . a:version . " db/structure.sql")
      return 'up'
    else
      return 'down'
    endif
  elseif ShellOK('test -f db/schema.rb')
    " schema.rb only contains latest migration version
    if ShellOK("grep " . a:version . " db/schema.rb")
      return 'up'
    else
      " just assume the status is down
      return 'down'

      " or...
      " determine true status of migration
      let migration_status = split(ChomppedSystem("rails db:migrate:status | grep " . a:version))[0]
      return l:migration_status
    endif
  endif
  throw "Can't determine migration status"
endfunction

function! RunRailsMigration(version)
  let migration_status = RailsMigrationStatus(a:version)

  if l:migration_status == 'up'
    call Shell("rake db:migrate:down VERSION=" . a:version)
  elseif l:migration_status == 'down'
    call Shell("rake db:migrate:up VERSION=" . a:version)
  endif
endfunction

function! RunCurrentTest(context)
  let l:test_command = TestCommand(a:context)
  if type(l:test_command) == 1
    call Shell(l:test_command)
  else
    echom 'No test to run'
  endif
endfunction

function! RunSavedTest()
  silent! write
  let l:test_command = SavedTestCommand()
  if type(l:test_command) == 1
    call Shell(l:test_command)
  endif
endfunction

function! SavedTestCommand()
  if exists("g:saved_test_command")
    return g:saved_test_command
  endif
endfunction

function! SetTestCommand(context)
  call SetTestFile()
  if a:context == 'at_line'
    call SetTestFileLine()
    let line_options = ":" . TestFileLine()
  else
    let line_options = ""
  endif
  let g:saved_test_command = TestRunner() . TestFile() . l:line_options
endfunction

function! TestCommand(context)
  if InTestFile()
    call SetTestCommand(a:context)
  end
  return SavedTestCommand()
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

function! ChomppedSystem(command)
  " strip away the last byte of output
  return system(a:command)[:-2]
endfunction

function! Shell(command)
  if ShouldSendOutputToTmux()
    call AsyncShell("tt \" clear && cd " . getcwd() . " && time " . a:command . "\"")
  else
    execute ":!clear && time " . a:command
  endif
endfunction

function! AsyncShell(command)
  let job = job_start(['sh', '-c', a:command])
endfunction

function! TestRunner()
  if &filetype == "javascript" || &filetype == "javascript.jsx"
    return " yarn jest "
  else
    return " rspec --color --tty -f doc "
  endif
endfunction

function! ShellOK(command)
  call system(a:command)

  let return_code = v:shell_error

  " 0 is falsy in VimScript
  if return_code == 0
    return 1
  else
    return 0
  endif
endfunction

function! InTestFile()
  let pattern = '\(.feature\|_spec.rb\|_test.rb\|test.js\)$'
  return match(expand("%"), pattern) != -1
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
  return system("iterm_session_profile")
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

function! InteractiveRuby()
  if ShellOK('which pry')
    let l:irb = 'pry'
  else
    let l:irb = 'irb'
  endif
  call Shell(l:irb . ' -r ' . expand('%:p'))
endfunction

" Creates a find command ignoring paths and files set in wildignore
function! FindWithWildignore(path)
  let excluding=""
  for entry in split(&wildignore,",")
    let excluding.= (match(entry,'*/*') ? " ! -ipath \'" . a:path . "/" : " ! -iname \'") . entry . "\' "
  endfor
  if len(excluding) > 0
    return "find " . a:path . "/* -type f \\\( " . excluding . " \\\)"
  else
    return "find " . a:path . "/* -type f"
  end
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
  if InGitDir()
    call SelectaGitFile(a:path)
  else
    call SelectaFoundFile(a:path)
  endif
endfunction

function! SelectaFoundFile(path)
  call SelectaCommand(FindWithWildignore(a:path), "", ":e")
endfunction

function! SelectaGitFile(path)
  call SelectaCommand("git ls-files --cached --others --exclude-standard " . a:path . " | uniq", "", ":e")
endfunction

function! SelectaGitCurrentBranchFile()
  call SelectaCommand("git diff --name-only $(git merge-base --fork-point " . $DEFAULT_BRANCH . ")", "", ":e")
endfunction

" Fuzzy select
function! SelectaIdentifier()
  " Yank the word under the cursor into the z register
  normal "zyiw
  " Fuzzy match files in the current directory, starting with the word under
  " the cursor
  call SelectaCommand("find * -type f", "-s " . @z, ":e")
endfunction

function! SelectaBuffer()
  let bufnrs = filter(range(1, bufnr("$")), 'buflisted(v:val)')
  let buffers = map(bufnrs, 'bufname(v:val)')
  call SelectaCommand('echo "' . join(buffers, "\n") . '"', "", ":b")
endfunction

function! ShouldToExpect()
  %s/\(\S\+\).should\(\s\+\)==\s*\(.\+\)/expect(\1).to\2eq(\3)/
endfunction

function! OpenAlternateFile(path)
  let l:alternate = system("alt " . a:path)
  if empty(l:alternate)
    echom "No alternate file for " . a:path
  else
    exec ':e ' . l:alternate
  endif
endfunction

function! InGitDir()
  call system("git rev-parse --git-dir")
  return v:shell_error == 0
endfunction

function! CdToProjectRoot()
  if InGitDir()
    exec 'cd ' . system("git rev-parse --show-toplevel")
  endif
endfunction

function! LetToInstanceMethod()
  :s/let../@/
  :s/) { / = /
  :s/ }$//
endfunction

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

function! LongestLine()
  return system("gwc -L " . bufname("%") . " | cut -d ' ' -f 1")
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

function! SetColorscheme()
  if $TERM_PROGRAM =~ 'Apple_Terminal'
    colorscheme Tomorrow-Night-Bright
  elseif ItermProfile() =~ 'Solarized'
    colorscheme solarized
    if ItermProfile() =~ 'Light'
      set background=light
    else
      set background=dark
    endif
  else
    colorscheme Tomorrow-Night-Bright
  endif
endfunction

function! AutocmdCommitMessage()
  let b:noResumeCursorPosition=1
  setlocal textwidth=72
  setlocal colorcolumn=72
endfunction

function! AutocmdPullRequestMessage()
  let b:noResumeCursorPosition=1
endfunction

function! GitLogPatch()
  let dir = expand('%:h')
  let file = expand('%')
  exec ":silent !cd " . dir . " && git lp " . file
  redraw!
endfunction
