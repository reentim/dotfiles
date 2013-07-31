" Pathogenesis
  call pathogen#infect()
  call pathogen#helptags()

" General
" ==============================================================================
  " Sensible defaults
    set nocompatible
    set backspace=indent,eol,start
    set history=10000
    set encoding=utf-8
    set showcmd
    set ttyfast
    set ttimeout
    set ttimeoutlen=10
    set shell=bash
    set mouse=a
    syntax on

  " Actual preferences
    set nonumber
    set showmatch
    set wildmenu
    set sidescrolloff=5
    set autoread
    let mapleader = ","

" Aesthetics
" ==============================================================================
  set t_Co=256
  set colorcolumn=80
  set ruler
  colorscheme solarized
  set background=dark

  " Italic comments. This requires a terminal emulator that supports italic
  " text, e.g. iTerm2 with setting enabled, and an appropriate TERMINFO (see
  " https://gist.github.com/sos4nt/3187620).
  " If echo `tput sitm`italics`tput ritm` produces italic text, then this should
  " work (maybe)
    highlight Comment cterm=italic

" Filetype dependent formatting
" ==============================================================================
  filetype plugin indent on

  autocmd FileType php,c,sh
    \ setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab

  " Spell-checking
    if has('spell')
      autocmd BufNewFile,BufRead COMMIT_EDITMSG setlocal spell
      autocmd FileType eruby                    setlocal spell
      autocmd FileType markdown                 setlocal spell
      autocmd BufNewFile,BufRead *.tpl.php      setlocal spell
      autocmd BufNewFile,BufRead html           setlocal spell
    endif

" Plugins
" ==============================================================================
  " Surround
    " with method: ascii 'm'
      autocmd FileType javascript let b:surround_109 = "function() { \r }"
      autocmd FileType ruby       let b:surround_109 = "def \r end"

    " with if: ascii 'i'
      autocmd FileType javascript let b:surround_105 = "if () { \r }"
      autocmd FileType ruby       let b:surround_105 = "if \r end"

  " Powerline
    set noshowmode
    set laststatus=2
    let g:Powerline_colorscheme='solarized256_dark'

  " Syntastic
    let g:syntastic_mode_map = { 'mode': 'passive' }

  " indent html
    let g:html_indent_inctags = "html,body,head,tbody"
    let g:html_indent_script1 = "inc"
    let g:html_indent_style1 = "inc"

  " delimitmate
    let delimitMate_expand_cr = 1
    let delimitMate_expand_space = 1

  " Indent Guides
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_auto_colors = 0

    " Tomorrow-Night-Eighties
      " hi IndentGuidesOdd  guibg=red   ctermbg=236
      " hi IndentGuidesEven guibg=green ctermbg=238

    " Tomorrow-Night-Bright
      " hi IndentGuidesOdd  guibg=red   ctermbg=235
      " hi IndentGuidesEven guibg=green ctermbg=237

    " Solarized Dark
      hi IndentGuidesOdd  guibg=red   ctermbg=0
      hi IndentGuidesEven guibg=green ctermbg=8

  " Command-t
    let g:CommandTMaxFiles=99000
    let g:CommandTMatchWindowReverse=1
    let g:CommandTClearMap='<C-w>'
    set wildignore+=public/css
    set wildignore+=*.png,*.jpg,*.gif
    set wildignore+=*.doc,*.docx,*.xls,*.xlsx,*.rtf,*.pdf
    set wildignore+=*.mp3,*.mp4,*.mkv,*.avi,*.zip,*.rar,*.iso,*.dmg,*.gz
    nnoremap <leader>t  :wa\|:CommandTFlush<CR>\|:CommandT<CR>

  " Ctrl-P
    let g:ctrlp_working_path_mode = ''

  " Ultisnips
    let g:UltiSnipsExpandTrigger      = "<C-]>"
    let g:UltiSnipsJumpForwardTrigger = "<C-]>"
    let g:UltiSnipsSnippetsDir        = "~/.vim/bundle/snippets/UltiSnips"

  " coffee-script
    highlight link coffeeSpaceError NONE

" Whitespace
" ==============================================================================
  set nowrap
  set textwidth=80
  set expandtab tabstop=2 softtabstop=2 shiftwidth=2
  set autoindent
  set smartindent

  " Highlight trailing whitespace, but not during insertion
    highlight TrailingWhitespace ctermbg=red guibg=red
    au BufEnter    * match TrailingWhitespace /\s\+$/
    au InsertEnter * match TrailingWhitespace /\s\+\%#\@<!$/
    au InsertLeave * match TrailingWhitespace /\s\+$/
    au BufWinLeave * call clearmatches()

  " Trim trailing whitespace on command
    nnoremap <leader>rw :call TrimWhiteSpace()<CR>
    function! TrimWhiteSpace()
      %s/\s\+$//e
      normal ``
    endfunction

" Searching
" ==============================================================================
  set hlsearch
  set incsearch
  set ignorecase
  set smartcase
  nnoremap <silent> <CR> :nohlsearch<CR>

  " Search for selected text, forwards or backwards
  " -----------------------------------------------
    vnoremap <silent> * :<C-U>
      \ let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
      \ gvy/<C-R><C-R>=substitute(
      \ escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
      \ gV:call setreg('"', old_reg, old_regtype)<CR>

  " Standardise regex handling
  " --------------------------
    nnoremap / /\v
    vnoremap / /\v

" Leader shortcuts
" ==============================================================================
  " Edit .vimrc in new vertical window
    nnoremap <leader>ev :e $MYVIMRC<CR>

  " Edit snippets
    nnoremap <leader>es :execute "e ~/.vim/bundle/snippets/UltiSnips/" . &filetype . ".snippets"<CR>

  " Open current file / directory in MacOS
    nnoremap <leader>o :!open %<CR><CR>
    nnoremap <leader>d :!open <C-R>=expand('%:p:h').'/'<CR><CR>

  " Run scripts
    autocmd FileType sh,bash    nnoremap <leader>r :w\|:!clear && time bash %:p<CR>
    autocmd FileType rb,ruby    nnoremap <leader>r :w\|:!clear && time ruby %:p<CR>
    autocmd FileType py,python  nnoremap <leader>r :w\|:!clear && time python %:p<CR>
    autocmd FileType javascript nnoremap <leader>r :w\|:!clear && time node %:p<CR>
    autocmd FileType c          nnoremap <leader>r :w\|:silent! !gcc %:p<CR>:!time ./a.out<CR>
    autocmd FileType vim        nnoremap <leader>r :w\|:source %:p<CR>

  " Run tests / specs
    nnoremap <leader>f :wa\|:!clear && time bundle exec rspec --color --tty --format documentation %<CR>
    nnoremap <leader>z :wa\|:!clear && time zeus rspec --color --tty --format documentation %<CR>

  " Load Ruby into irb session
    autocmd FileType rb,ruby    nnoremap <leader>a :w\|:!clear && irb -r %:p<CR>

  " Compile CoffeeScript
    nnoremap <leader>q :!coffee --compile %<CR><CR>

  " Split HTML attributes
    nnoremap <leader>S :call SplitHTMLAttrs()<CR>
    function! SplitHTMLAttrs()
      normal 0dw
      :s/ /\r/g

      " fix indentation, for self closing tags, will indent parent and move
      " cursor...
      normal vat=

      " ...so move it back
      normal `._
    endfunction

  " Shortcut to invoke watch / browser refresh script in background...
  " ------------------------------------------------------------------
    let g:watching = 0
    nnoremap <leader>c :call SetWatch()<CR><CR>
    function! SetWatch()
      :!watch '%:p:h' > /dev/null 2>&1 &
      let g:watching = 1
    endfunction

    " ...and tidy up afterwards
      au VimLeave * :call RemoveWatch()
      function! RemoveWatch()
        if g:watching == 1
          :!pkill ruby /usr/local/bin/watch
        endif
      endfunction

  " Paste mode
    nnoremap <leader>p :set invpaste<CR>

  " Comment underlining: relies on vim-commentary plugin
  " ----------------------------------------------------
    nnoremap <leader>l :call UnderlineComment()<CR>
    function! UnderlineComment()
      " uncomment current line
      normal \\l
      " yank line, paste below
      normal yyp
      " visually select pasted line, replace all with '-'
      normal v$r-
      " comment out underline, re-comment original comment
      normal \\k
    endfunction

  " 80 character '=' underline
    nnoremap <leader>8 yypd$aa<ESC>\\lyypd$80a=<ESC>:norm 80\|<CR>d$khljd^\\lkddk

" Folding
" ==============================================================================
  set foldmethod=indent
  set nofoldenable

" Buffers and windows
" ==============================================================================
  set hidden

  " switch to new split window
    nnoremap <leader>w <C-w>v<C-w>l
    nnoremap <leader>h :split<CR><C-w>j

  " moving around windows
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l

" Behaviour
" ==============================================================================
  " Central temporary directories
    set backup
    set backupdir=/tmp/vimtemp//
    set dir=/tmp/vimswap//
    set undofile
    set undodir=/tmp/vimundo//

  " When Vim opens, jump to last cursor position unless it's invalid or in an
  " event handler
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

  " Agressive autosaving
    autocmd InsertLeave * silent! update
    autocmd CursorMoved * silent! update
    autocmd BufLeave,FocusLost * silent! wall

  " Toggle the display of invisible characters
    nnoremap <F5> :set invlist<CR>
    set listchars=tab:▸\ ,eol:↵
    set listchars+=trail:.
    set listchars+=extends:>
    set listchars+=precedes:<

" General custom mappings
" ==============================================================================
  nnoremap ; :
  inoremap jk <ESC>
  nnoremap <leader><leader> <c-^>

  " :bdelete also closes the current window; let's fix that
    command! Bd bp|sp|bn|bd
    cabbrev bd Bd

  " Make Y consistent with C and D.  See :help Y.
    nnoremap Y y$

  " Get directory of current file
    cnoremap %% <C-R>=expand('%:p:h').'/'<CR>

  " Hash rockets and arrows
    inoremap <c-l> =><space>
    inoremap <c-j> ->

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
    function! NextIndent(exclusive, fwd, lowerlevel, skipblanks)
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

    " Moving back and forth between lines of same or lower indentation.
      nnoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
      nnoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
      nnoremap <silent> [L :call NextIndent(0, 0, 1, 1)<CR>
      nnoremap <silent> ]L :call NextIndent(0, 1, 1, 1)<CR>
      vnoremap <silent> [l <Esc>:call NextIndent(0, 0, 0, 1)<CR>m'gv''
      vnoremap <silent> ]l <Esc>:call NextIndent(0, 1, 0, 1)<CR>m'gv''
      vnoremap <silent> [L <Esc>:call NextIndent(0, 0, 1, 1)<CR>m'gv''
      vnoremap <silent> ]L <Esc>:call NextIndent(0, 1, 1, 1)<CR>m'gv''
      onoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
      onoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
      onoremap <silent> [L :call NextIndent(1, 0, 1, 1)<CR>
      onoremap <silent> ]L :call NextIndent(1, 1, 1, 1)<CR>
