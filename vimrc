" General
" ================================================================================
  " Sensible defaults
  set nocompatible
  set backspace=indent,eol,start
  set history=10000
  set encoding=utf-8
  set fileencoding=utf-8
  set showcmd
  set ttyfast
  set ttimeout
  set ttimeoutlen=10
  set shell=bash
  syntax on

  " Pathogen
    call pathogen#infect()
    call pathogen#helptags()

  " Load functions
    if filereadable(expand("~/.vim/functions.vim"))
      source ~/.vim/functions.vim
    endif

  " Actual preferences
    set autoread
    set mouse=a
    set ttymouse=sgr " 'The mouse works even in columns beyond 223'
    set showmatch
    set nowrap

    if LongestLine() <= 80
      set textwidth=80
    endif

    set colorcolumn=80
    set splitright
    set splitbelow
    set noequalalways
    let mapleader = ","
    set nojoinspaces
    set winheight=16
    set winwidth=86
    set cursorline

    " Use the old vim regex engine for faster syntax highlighting
    set re=1

    " Netw directory listing
    let g:netrw_liststyle = 3
    let g:netrw_browse_split = 4
    let g:netrw_winsize = 20

    " this is useful if leaving Netrw open
    " set noequalalways

" Aesthetics
" ==============================================================================
  set nu
  set wildmenu
  set ruler
  set laststatus=2
  set t_Co=256
  set fillchars+=vert:\ " Hide pipe character in window separators

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

  " Italic comments. This requires a terminal emulator that supports italic
  " text, e.g. iTerm2 with setting enabled, and an appropriate TERMINFO (see
  " https://gist.github.com/sos4nt/3187620).
  " If echo `tput sitm`italics`tput ritm` produces italic text, then this should
  " work (maybe)
    if &term =~ "italic" || &term =~ "tmux"
      highlight Comment cterm=italic
    endif

" Filetype dependent formatting
" ==============================================================================
  filetype plugin indent on
  set autoindent
  set smartindent
  set expandtab tabstop=4 softtabstop=2 shiftwidth=2

  augroup vimrc
    autocmd!

    autocmd FileType ruby :call CdToProjectRoot()

    autocmd BufNewFile,BufRead COMMIT_EDITMSG setlocal textwidth=72
    autocmd BufNewFile,BufRead COMMIT_EDITMSG setlocal colorcolumn=72

    autocmd BufNewFile,BufRead PULLREQ_EDITMSG setlocal nowrap

    autocmd FileType php,c
      \ setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab

    autocmd FileType gitcommit let b:noResumeCursorPosition=1
    autocmd FileType gitrebase let b:noResumeCursorPosition=1
    autocmd FileType gitrebase :call InteractiveRebaseFixup()

  " Spell-checking
    if has('spell')
      autocmd BufNewFile,BufRead PULLREQ_EDITMSG setlocal spell
      autocmd BufNewFile,BufRead COMMIT_EDITMSG  setlocal spell
      autocmd FileType eruby                     setlocal spell
      autocmd FileType markdown                  setlocal spell
      autocmd BufNewFile,BufRead html            setlocal spell
    endif

  " When Vim opens, jump to last cursor position
    autocmd BufReadPost * call ResumeCursorPosition()

  " Aggressive autosaving
    autocmd InsertLeave * silent! update
    autocmd CursorMoved * silent! update
    autocmd BufLeave,FocusLost * silent! wall

    nnoremap <silent> \ :nohl<CR>

    " jrnl journaling tool
    autocmd BufNewFile,BufRead jrnl*,*journal.txt call SetJournalOptions()

  " Surround
    " with method: ascii 'm'
      autocmd FileType javascript let b:surround_109 = "function() { \r }"
      autocmd FileType ruby       let b:surround_109 = "def \r end"

    " with if: ascii 'i'
      autocmd FileType javascript let b:surround_105 = "if () { \r }"
      autocmd FileType ruby       let b:surround_105 = "if \r end"

    " Ultisnips
      autocmd FileType javascript.jsx :UltiSnipsAddFiletypes html

    " Tell vim-commentary about JSX
    autocmd FileType javascript.jsx setlocal commentstring={/*\ %s\ */}

    " Highlight trailing whitespace, but not during insertion, and not in help
    highlight TrailingWhitespace ctermbg=red guibg=red
    autocmd BufEnter    * match TrailingWhitespace /\s\+$/
    autocmd InsertEnter * match TrailingWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match TrailingWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()
  augroup END

" Plugins
" ==============================================================================
  " ALE - Asynchronous Lint Engine
  let g:ale_completion_delay = 50
  let g:ale_enabled = 1
  let g:ale_sign_column_always = 1
	let g:ale_fixers = {
	\ 'javascript': ['eslint', 'prettier'],
  \ 'ruby': ['rufo', 'rubocop'],
	\}
	let g:ale_pattern_options = {
	\ '.*schema\.rb$': {'ale_enabled': 0},
	\}
  nnoremap ]a :ALENext<CR>
  nnoremap [a :ALEPrevious<CR>

  cnoreabbrev alefix ALEFix


  " Splitjoin
    let g:splitjoin_ruby_hanging_args = 0
    let g:splitjoin_ruby_curly_braces = 0
    let g:splitjoin_trailing_comma = 0 " je regret

  " indent html
    let g:html_indent_inctags = "html,body,head,tbody,p,li,label,g"
    let g:html_indent_script1 = "inc"
    let g:html_indent_style1 = "inc"

  " Delimitmate
    let delimitMate_expand_cr = 1
    let delimitMate_expand_space = 1

  " Indent Guides
    let g:indent_guides_enable_on_vim_startup = 1
    if exists('g:colorscheme_indent_guide_odd')
      let g:indent_guides_auto_colors = 0
      exe "hi IndentGuidesOdd  ctermbg=" . g:colorscheme_indent_guide_odd
      exe "hi IndentGuidesEven ctermbg=" . g:colorscheme_indent_guide_even
    endif

    " nnoremap <leader>h :CommandTHelp<CR>

  " Selecta replaces CommandT
    nnoremap <leader>t  :call SelectaFile(".")<CR>
    nnoremap <leader>gc :call SelectaFile("app/controllers")<CR>
    nnoremap <leader>gl :call SelectaFile("lib")<CR>
    nnoremap <leader>gm :call SelectaFile("app/models")<CR>
    nnoremap <leader>gp :call SelectaFile("app/javascript/packs")<CR>
    nnoremap <leader>gq :call SelectaFile("app/graphql")<CR>
    nnoremap <leader>gs :call SelectaFile("spec")<CR>
    nnoremap <leader>gv :call SelectaFile("app/views")<CR>

    " Branch files
    nnoremap <leader>gb :call SelectaGitCurrentBranchFile()<CR>

    " Fuzzy select git files in current file directory
    nnoremap <leader>gd :call SelectaGitFile(expand('%:p:h'))<CR>

    " Fuzzy select a buffer. Open the selected buffer with :b.
    nnoremap <leader>b :call SelectaBuffer()<CR>

    nnoremap <c-g> :call SelectaIdentifier()<CR>

  " Ultisnips
    let g:UltiSnipsExpandTrigger      = "<C-]>"
    let g:UltiSnipsJumpForwardTrigger = "<C-]>"
    let g:ultisnips_javascript = {
          \ 'keyword-spacing': 'always',
          \ 'semi': 'never',
          \ 'space-before-function-paren': 'always',
          \ }

  " coffee-script
    highlight link coffeeSpaceError NONE

  " JSX
    let g:jsx_ext_required = 0

  " Ack - use Ag
    let g:ackprg = 'ag --nogroup --nocolor --column'
    let g:ackhighlight = 1
    cabbrev Ag Ack

    " Using vim's :grep, :copen, :cn, :cp to come close to Ack.vim
    set grepprg=ag\ --vimgrep\ $*
    set grepformat=%f:%l:%c:%m

" Searching
" ==============================================================================
  set hlsearch
  execute ":nohlsearch"
  set incsearch
  set ignorecase
  set smartcase

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
  " Edit vim-related files
    nnoremap <leader>ev :e $MYVIMRC<CR>
    nnoremap <leader>ef :e ~/.dotfiles/vim/functions.vim<CR>

  " Reload .vimrc
    nnoremap <leader>er :source $MYVIMRC<CR>

  " Edit snippets
    nnoremap <leader>es :UltiSnipsEdit!<CR>

  " Open current file / directory in MacOS
    nnoremap <leader>o :!open %<CR><CR>
    nnoremap <leader>d :!open <C-R>=expand('%:p:h').'/'<CR><CR>

  " Run scripts
    nnoremap <leader>r :call RunFile()<CR>

  " Run tests
    nnoremap <leader>f :call RunCurrentTest('full_test')<CR>
    nnoremap <leader>z :call RunCurrentTest('at_line')<CR>
    nnoremap <CR> :call RunSavedTest()<CR>

  " Split HTML attributes, Ruby lines
    nnoremap <leader>S :silent! call SplitLine()<CR>

  " Paste mode
    nnoremap <leader>p :set invpaste<CR>

  " Add pry binding
    nnoremap <leader>pr ddObinding.pry<ESC>

  " Parenthesise
    nnoremap <leader>P _f r(<ESC>$a)<ESC>

  " Switching between tests and code
    nnoremap <leader>. :call OpenTestAlternate()<CR>

  " Search for conflict markers
    nnoremap <leader>m /\v^(\<\<\<\<\<\<\<(.*)\|\=\=\=\=\=\=\=\|\>\>\>\>\>\>\>(.*))<CR>

  " Underlining, relies on vim-commentary plugin
  " --------------------------------------------
    nnoremap <leader>l :call Underline('-')<CR>
    nnoremap <leader>u :call Underline('=')<CR>

  " 80 character underline
    nnoremap <silent> <leader>8l :call FullUnderline('-')<CR>
    nnoremap <silent> <leader>8u :call FullUnderline('=')<CR>

" Folding
" ==============================================================================
  set foldmethod=indent
  set foldminlines=0
  set nofoldenable

" Buffers and windows
" ==============================================================================
  set hidden

  " switch to new split window
    nnoremap <leader>w <C-w>v<C-w>l
    nnoremap <leader>h :split<CR><C-w>j

" Behaviour
" ==============================================================================
  " Central temporary directories
    set backup
    set backupdir=/tmp/vimtemp//
    set dir=/tmp/vimswap//
    set undofile
    set undodir=/tmp/vimundo//

  " Toggle the display of invisible characters
    nnoremap <F5> :set invlist<CR>
    set listchars=tab:▸\ ,eol:↵
    set listchars+=trail:.
    set listchars+=extends:>
    set listchars+=precedes:<

" Ctags
" ==============================================================================
  set tags+=.git/tags

" General custom mappings
" ==============================================================================
  nnoremap ; :
  inoremap jk <ESC>
  nnoremap <leader><leader> <C-^>

  " Make Y consistent with C and D.  See :help Y.
    nnoremap Y y$

  " Get directory of current file, relative to current path
    cnoremap %% <C-R>=expand('%:.:h').'/'<CR>

  " Hash rockets and arrows
    inoremap <c-l> =><space>
    inoremap <c-j> ->

    nnoremap <leader>pr ddObinding.pry<ESC>

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

    " text-object based on matchit matching
    vnoremap ac :<C-U>silent! normal! V<C-U>call <SNR>51_Match_wrapper('',1,'v') <CR>m'gv``
    onoremap ac :normal Vaf<CR>

    " CloseBuffer has some bugs! It leaves cursor in strange place
    "
    " command! BD :call DeleteInactiveBufs()
    " command! Bd :call CloseBuffer()
    " cnoreabbrev bd Bd
    " cnoreabbrev Bd BD

    nnoremap <leader>n :call RenameFile()<CR>
    nnoremap <leader>s :call SortIndentLevel()<CR>

		" " This is for working with Relay
		" set includeexpr=substitute(v:fname,'Loader','','')
		" set path+=app/javascript/packs/**

    " Italics handling (neccessary?)
		let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
		let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

    " Scale back completion sources because the completion window sometimes has
    " a big delay to show up -- maybe due to tags?
    set complete=.,w,b,u
