if filereadable(expand("~/.vim/lightline.vim"))
  source ~/.vim/lightline.vim
endif

if filereadable(expand("~/.vim/colorscheme.vim"))
  source ~/.vim/colorscheme.vim
endif

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
    echoerr "Underline() requires vim-commentary plugin."
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

function! RailsMigrationStatus(version)
  let db_has_version = System(
        \"db_has_schema_version -d $(finddb) -v "
        \ . a:version
        \)
  if l:db_has_schema_version == "true"
    return "up"
  elseif l:db_has_schema_version == "false"
    return "down"
  else
    echoerr "Can't determine migration status"
  endif
endfunction

function! RailsMigrationCmd(version)
  let migration_status = RailsMigrationStatus(a:version)

  if l:migration_status == 'up'
    return "rake db:migrate:down VERSION=" . a:version
  elseif l:migration_status == 'down'
    return "rake db:migrate:up VERSION=" . a:version
  endif
endfunction

function! _Executor(ft, filepath, ...)
  let opts = get(a:000, 0, {})

  " TODO: is there a way to create a path type useable in expand()?
  let filename = System("basename \"" . a:filepath . "\"")
  let host_dir = substitute(a:filepath, "/" . l:filename . "$", "", "")
  let root = substitute(a:filepath, "\\..*$", "", "")
  let path = '"' . a:filepath . '"'

  if a:ft =~ '\(bash\|sh\)'
    return "bash " . l:path
  elseif a:ft == "ruby"
    if l:filename =~ '\(_spec\|test\).rb$'
      return "rspec --color --tty -f doc " . l:path . get(l:opts, 'postfix', '')
    elseif l:filename == "Gemfile"
      return "bundle install"
    elseif l:host_dir == "db/migrate"
      return RailsMigrationCmd(split(l:filename, "_")[0])
    elseif l:filename == "routes.rb"
      return "routes routes"
    elseif a:filepath =~ "babushka"
      return "babushka " . DepUnderCursor()
    else
      return "ruby " . l:path
    endif
  elseif a:ft == "python"
    return "python " . l:path
  elseif l:filename =~ 'test.js$'
    return "yarn jest "
  elseif a:ft == "javascript"
    return "node " . l:path
  elseif a:ft == "vim"
    if l:filename == "functions.vim"
      execute ":echom " . VimFunctionUnderCursor()
      return 0
    endif
  elseif a:ft == "c"
    return "gcc " . l:path . " -o " . l:root . " && clear && ./" . l:root
  endif
  return 0
endfunction

function! RunFile(...)
  let opts = get(a:000, 0, {})
  let executor = _Executor(&ft, expand("%:p"), l:opts)
  if l:executor != 1
    echom l:executor
    call Shell(l:executor)
    let g:saved_command = l:executor
  endif
endfunction

function! RunSavedCommand()
  if exists("g:saved_command")
    echom g:saved_command
    call Shell(g:saved_command)
  else
    echom "No saved command."
  endif
endfunction

function! RepeatVimCmd()
  let hist_index = -1
  while !IsRepeatableHistory(l:hist_index) && l:hist_index > -100
    let l:hist_index -= 1
  endwhile
  execute ":" . histget(":", l:hist_index)
endfunction

function! IsRepeatableHistory(hist_index)
  let cmd = histget(":", a:hist_index)
  return match(l:cmd, '^\(echom\|call\)') != -1
        \ && match(l:cmd, 'RepeatVimCmd') == -1
endfunction

function! System(command)
  " strip away the last byte of output
  return system(a:command)[:-2]
endfunction

function! Tmux()
  return $TMUX != ''
endfunction

function! Shell(command)
  if Tmux()
    call AsyncShell("tt \'pushd \"" . getcwd() . "\">/dev/null; time " . a:command . "; popd>/dev/null'")
  else
    execute ":!clear; time " . a:command
  endif
endfunction

function! AsyncShell(command)
  let job = job_start(['sh', '-c', a:command])
endfunction

function! ShellOK(command)
  call system(a:command)
  return v:shell_error == 0 ? 1 : 0
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
  return system("iterm current_profile")
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
  call Shell(l:irb . ' -r "' . expand('%:p') . '"')
endfunction

function! ItalicComments_enable()
  " Italic comments. This requires a terminal emulator that supports italic
  " text. If "echo `tput sitm`italics`tput ritm`" produces italic text, then
  " this should work
  if &term =~ "italic" || &term =~ "tmux"
    highlight Comment cterm=italic
  endif
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

function! FuzzyFind(path)
  if exists('g:command_t_enabled')
    execute ":CommandT " . a:path
  else
    call SelectaFile(a:path)
  endif
endfunction

function! FuzzyFinder_configure()
  if exists("g:command_t_enabled")
    nnoremap <C-P> :call SelectaFile(".")<CR>
  elseif filereadable(expand("~/.vim/bundle/command-t/ruby/command-t/ext/command-t/ext.o"))
    nnoremap <C-P> :CommandT<CR>
  endif
endfunction

function! IndentGuideColors(...)
  let colorscheme = get(a:000, 0, Colorscheme_get())
  if l:colorscheme =~ 'solarized'
    if &background == 'dark'
      return [0, 8]
    else
      return [7, 15]
    endif
  elseif l:colorscheme =~ 'Tomorrow-Night$'
    return [236, 237]
  elseif l:colorscheme =~ 'Tomorrow-Night-Bright'
    return [236, 237]
  elseif l:colorscheme =~ 'Tomorrow-Night-Blue'
    return [18, 19]
  elseif l:colorscheme =~ 'Tomorrow-Night-Eighties'
    return [236, 238]
  elseif l:colorscheme =~ 'dracula'
    return [237, 236]
  elseif &background == 'light'
    return [254, 253]
  else
    return [234, 235]
  endif
endfunction

function! IndentGuideColors_set(...)
  let colors = get(a:000, 0, IndentGuideColors())
  let g:indent_guides_auto_colors = 0
  execute "hi IndentGuidesOdd  ctermbg=" . l:colors[0]
  execute "hi IndentGuidesEven ctermbg=" . l:colors[1]
endfunction

function! FuzzyFindBuffer()
  if exists('g:command_t_enabled')
    :CommandTBuffer
  else
    call SelectaBuffer()
  endif
endfunction

function! SelectaCommand(choice_command, ...)
  let selecta_args = get(get(a:000, 0, {}), "selecta", "")
  let vim_command = get(get(a:000, 0, {}), "vim")
  try
    let selection = system(a:choice_command . " | selecta " . l:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  if !empty(l:vim_command)
    exec l:vim_command . " " . l:selection
  else
    return l:selection
  endif
endfunction

function! SelectaFile(path)
  if InGitDir()
    call SelectaGitFile(a:path)
  else
    call SelectaFoundFile(a:path)
  endif
endfunction

function! SelectaMRUFoundFile(path)
  call SelectaCommand("ls -dt $(" . FindWithWildignore(a:path) . ")", {"vim": ":e"})
endfunction

function! SelectaFoundFile(path)
  call SelectaCommand(FindWithWildignore(a:path), {"vim": ":e"})
endfunction

function! SelectaGitFile(path)
  let choice = "git ls-files --cached --others --exclude-standard " . a:path . " | uniq"
  call SelectaCommand(l:choice, {"vim": ":e"})
endfunction

function! SelectaGitMRUFile(path)
  let choice = "ls -dt $(git ls-files --cached --others --exclude-standard " . a:path . " | uniq)"
  call SelectaCommand(l:choice, {"vim": ":e"})
endfunction

function! SelectaGitCurrentBranchFile()
  let choice = "git diff --name-only $(git merge-base --fork-point " . $DEFAULT_BRANCH . ")"
  call SelectaCommand(l:choice, {"vim": ":e"})
endfunction

function! SelectaGitCommitFile(revision)
  let choice = "git diff --name-only " . a:revision . "~"
  call SelectaCommand(l:choice, {"vim": ":e"})
endfunction

" Fuzzy select
function! SelectaIdentifier()
  " Yank the word under the cursor into the z register
  normal "zyiw
  " Fuzzy match files in the current directory, starting with the word under
  " the cursor
  call SelectaCommand("find * -type f", {"selecta": "-s " . @z}, {"vim": ":e"})
endfunction

function! SelectaBuffer()
  let bufnrs = filter(range(1, bufnr("$")), 'buflisted(v:val)')
  let buffers = map(bufnrs, 'bufname(v:val)')
  call SelectaCommand('echo "' . join(buffers, "\n") . '"', {"vim": ":b"})
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

function! InGitDir(...)
  let dir = get(a:000, 0, getcwd())

  return ShellOK("cd " . l:dir . " && git rev-parse --git-dir")
endfunction

function! GitTopLevelDir(...)
  let dir = get(a:000, 0, getcwd())

  let git_dir = System("cd " . l:dir . " && git rev-parse --show-toplevel 2>/dev/null")
  return l:git_dir != "" ? l:git_dir : 0
endfunction

function! CdToProjectRoot()
  if &ft =~ '\(fugitiveblame\|git\|help\)'
    return 1
  endif
  let file_git_dir = GitTopLevelDir(expand("%:h"))
  if type(l:file_git_dir) == 1
    exec "lcd " . l:file_git_dir
    return 1
  endif
  return 0
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
  " Comments should be fixed to the line they follow
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

function! BashIfToShortCircuit()
  normal vipJD
  :s/^.*\((\|\[\)/\1/g
  normal f;ce &&
endfunction

function! EnsureTempDirs()
  call system("mkdir -p ~/.tmp/vimtemp ~/.tmp/vimswap ~/.tmp/vimundo")
endfunction

function! DepUnderCursor()
  let line_no = line(".")
  let line = getline(".")
  while line !~ "^dep"
    let line = getline(line_no)
    let line_no -= 1
  endwhile
  return trim(substitute(substitute(line, "^dep ", "", ""), " do$", "", ""), "'\"")
endfunction

function! VimFunctionUnderCursor()
  let line_no = line(".")
  while getline(l:line_no) !~ "^function!"
    let line_no -= 1
  endwhile
  return substitute(getline(l:line_no), "function! ", "", "")
endfunction

function! MakeExec()
  if ShellOK("chmod +x " . expand("%:p"))
    echom System("/usr/bin/stat -f %A " . expand("%:p"))
  else
    echom "Error"
  endif
endfunction

function! AbbrevTabHelp()
  return getcmdtype() == ":" && getcmdline() == "h" ? "tab help" : "h"
endfunction

function! AbbrevRemapRun()
  return getcmdtype() == ":" && getcmdline() == "rr"
  \ ? "nnoremap <leader>r :w\\|:!clear;<CR>"
  \ : "rr"
endfunction

function! Profile_change(profile)
  call AsyncShell("prof " . a:profile)
  call Colorscheme_set({"profile": a:profile})
endfunction
