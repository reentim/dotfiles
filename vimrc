let mapleader = ','

set autoread
set backspace=indent,eol,start
set backup
set backupdir=~/.tmp/vimtemp//
set colorcolumn=80
set cursorline
set dir=~/.tmp/vimswap//
set encoding=utf-8
set fileencoding=utf-8
set fillchars+=vert:\ " Hide pipe character in window separators
set foldmethod=indent
set foldminlines=0
set grepformat=%f:%l:%c:%m
set grepprg=ag\ --vimgrep\ $*
set hidden
set history=10000
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set listchars=tab:▸\ ,eol:↵,extends:>,precedes:<,trail:.
set modelines=5
set mouse=a
set nocompatible
set noequalalways
set nofoldenable
set nojoinspaces
set nonu
set nowrap
set re=1 " Use the old vim regex engine for faster syntax highlighting
set ruler
set shell=bash
set showcmd
set showmatch
set showtabline=2
set smartcase
set splitbelow
set splitright
set t_Co=256
set tags+=.git/tags
set ttimeout
set ttimeoutlen=10
set ttyfast
set ttymouse=sgr " 'The mouse works even in columns beyond 223'
set undodir=~/.tmp/vimundo//
set undofile
set wildmenu
set winheight=16
set winwidth=72

execute ":nohlsearch"
syntax on

" Pathogen
call pathogen#infect()
call pathogen#helptags()

" Load functions
if filereadable(expand("~/.vim/functions.vim"))
  source ~/.vim/functions.vim
endif

let g:command_t_enabled=1

call EnsureTempDirs()
call SetColorscheme()

let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 20

" Italic comments. This requires a terminal emulator that supports italic
" text. If "echo `tput sitm`italics`tput ritm`" produces italic text, then
" this should work
if &term =~ "italic" || &term =~ "tmux"
  highlight Comment cterm=italic
endif

filetype plugin indent on
set autoindent
set smartindent
set expandtab tabstop=4 softtabstop=2 shiftwidth=2

augroup vimrc
  autocmd!

  autocmd BufNewFile,BufRead COMMIT_EDITMSG call AutocmdCommitMessage()
  autocmd BufNewFile,BufRead PULLREQ_EDITMSG call AutocmdPullRequestMessage()
  autocmd BufNewFile,BufRead jrnl*,*journal.txt call SetJournalOptions()
  autocmd BufWritePre,InsertLeave jrnl* call RewrapBuffer()
  autocmd BufNewFile,BufRead * call CdToProjectRoot()
  autocmd FileType c setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
  autocmd FileType crontab setlocal backupcopy=yes
  autocmd FileType eruby,markdown,html setlocal spell
  autocmd FileType gitrebase let b:noResumeCursorPosition=1
  autocmd FileType javascript.jsx :UltiSnipsAddFiletypes html
  autocmd FileType ruby nnoremap <buffer> <leader>a :call InteractiveRuby()<CR>
  autocmd Filetype make setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab

  autocmd InsertLeave,CursorMoved * silent! update
  autocmd BufLeave,FocusLost * silent! wall

  autocmd BufWritePost functions.vim source ~/.vim/functions.vim

  " Tell vim-commentary about JSX
  autocmd FileType javascript.jsx setlocal commentstring={/*\ %s\ */}

  " Highlight trailing whitespace, but not during insertion
  highlight TrailingWhitespace ctermbg=red guibg=red
  autocmd BufEnter    * match TrailingWhitespace /\s\+$/
  autocmd InsertEnter * match TrailingWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match TrailingWhitespace /\s\+$/
  autocmd BufWinLeave * call clearmatches()

  " run this last, to allow opting out
  autocmd BufReadPost * call ResumeCursorPosition()
augroup END

" ALE - Asynchronous Lint Engine
let g:ale_completion_delay = 50
let g:ale_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_fix_on_save_ignore = {'ruby': ['rubocop']}
let g:ale_sign_column_always = 0
let g:ale_linters = {
\ 'typescript': ['tsserver', 'tslint'],
\ 'javascript': ['eslint']
\}
let g:ale_fixers = {
\ 'javascript': ['eslint'],
\ 'typescript': ['prettier'],
\ 'html': ['prettier'],
\ 'css': ['prettier'],
\ 'ruby': ['rubocop'],
\}
let g:ale_pattern_options = {
\ '.*schema\.rb$': {'ale_enabled': 0},
\}

" Splitjoin
let g:splitjoin_ruby_hanging_args = 0
let g:splitjoin_ruby_curly_braces = 0
let g:splitjoin_trailing_comma = 1

" Delimitmate
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

let g:tsuquyomi_disable_quickfix = 1

" Indent Guides
let g:indent_guides_enable_on_vim_startup = 1
if exists('g:colorscheme_indent_guide_odd')
  let g:indent_guides_auto_colors = 0
  exe "hi IndentGuidesOdd  ctermbg=" . g:colorscheme_indent_guide_odd
  exe "hi IndentGuidesEven ctermbg=" . g:colorscheme_indent_guide_even
endif

" Ultisnips
let g:UltiSnipsExpandTrigger = "<C-]>"
let g:UltiSnipsJumpForwardTrigger = "<C-]>"
let g:ultisnips_javascript = {
  \ 'keyword-spacing': 'always',
  \ 'semi': 'never',
  \ 'space-before-function-paren': 'always',
\ }

" JSX
let g:jsx_ext_required = 0

" Ack - use Ag
let g:ackprg = 'ag --nogroup --nocolor --column'
let g:ackhighlight = 1

cnoreabbrev Ag Ack
cnoreabbrev alefix ALEFix

cnoreabbrev <expr> h AbbrevTabHelp()
cnoreabbrev <expr> rr AbbrevRemapRun()
cnoremap %% <C-R>=expand('%:.:h').'/'<CR>
inoremap <C-J> ->
inoremap <C-L> =><space>
inoremap jk <ESC>
nnoremap / /\v
nnoremap ; :
nnoremap <C-G> :call SelectaIdentifier()<CR>
nnoremap <F5> :set invlist<CR>
nnoremap <leader>, <C-^>
nnoremap <leader>. :call OpenAlternateFile(expand('%'))<CR>
nnoremap <leader>8l :call FullUnderline('-')<CR>
nnoremap <leader>8u :call FullUnderline('=')<CR>
nnoremap <leader>ad :ALEDisable<CR>
nnoremap <leader>ae :ALEEnable<CR>
nnoremap <leader>b :call FuzzyFindBuffer()<CR>
nnoremap <leader>d :call AsyncShell('open ' . expand('%:p:h'))<CR>
nnoremap <leader>ed :lcd ~/deps\|:e common.rb<CR>
nnoremap <leader>ef :e ~/.dotfiles/vim/functions.vim<CR>
nnoremap <leader>ep :e ~/.dotfiles/profile<CR>
nnoremap <leader>er :source $MYVIMRC<CR>
nnoremap <leader>es :UltiSnipsEdit!<CR>
nnoremap <leader>et :e ~/.dotfiles/tmux.conf<CR>
nnoremap <leader>ev :e ~/.dotfiles/vimrc<CR>
nnoremap <leader>ezf :e ~/.dotfiles/zsh/functions.zsh<CR>
nnoremap <leader>ez :e ~/.dotfiles/zshrc<CR>
nnoremap <leader>f :call RunCurrentTest('full_test')<CR>
nnoremap <leader>gb :call SelectaGitCurrentBranchFile()<CR>
nnoremap <leader>gc :call SelectaFile("app/controllers")<CR>
nnoremap <leader>gd :call SelectaGitFile(expand('%:p:h'))<CR>
nnoremap <leader>gj :call BashIfToShortCircuit()<CR>
nnoremap <leader>gl :call SelectaFile("lib")<CR>
nnoremap <leader>gm :call SelectaFile("app/models")<CR>
nnoremap <leader>gp :call SelectaFile("app/javascript/packs")<CR>
nnoremap <leader>gq :call SelectaFile("app/graphql")<CR>
nnoremap <leader>gs :call SelectaFile("spec")<CR>
nnoremap <leader>gv :call SelectaFile("app/views")<CR>
nnoremap <leader>h :split<CR>
nnoremap <leader>ll :call Underline('-')<CR>
nnoremap <leader>lp :call GitLogPatch()<CR>
nnoremap <leader>m /\v^(\<{7}.*\|\={7}\|\>{7}.*)<CR>
nnoremap <leader>n :call RenameFile()<CR>
nnoremap <leader>o :!open %<CR><CR>
nnoremap <leader>p :set invpaste<CR>
nnoremap <leader>r :call RunFile()<CR>
nnoremap <leader>s :call SortIndentLevel()<CR>
nnoremap <leader>t  :call FuzzyFind(".")<CR>
nnoremap <leader>u :call Underline('=')<CR>
nnoremap <leader>w :vsplit<CR>
nnoremap <leader>z :call RunCurrentTest('at_line')<CR>
nnoremap <silent> <CR> :nohl<CR>
nnoremap <silent> [L :call NextIndent(0, 0, 1, 1)<CR>
nnoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
nnoremap <silent> ]L :call NextIndent(0, 1, 1, 1)<CR>
nnoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
nnoremap Y y$
nnoremap [a :ALEPrevious<CR>
nnoremap \ :call RunSavedThing()<CR>
nnoremap ]a :ALENext<CR>
onoremap <silent> [L :call NextIndent(1, 0, 1, 1)<CR>
onoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
onoremap <silent> ]L :call NextIndent(1, 1, 1, 1)<CR>
onoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
vnoremap / /\v
vnoremap <silent> [L <Esc>:call NextIndent(0, 0, 1, 1)<CR>m'gv''
vnoremap <silent> [l <Esc>:call NextIndent(0, 0, 0, 1)<CR>m'gv''
vnoremap <silent> ]L <Esc>:call NextIndent(0, 1, 1, 1)<CR>m'gv''
vnoremap <silent> ]l <Esc>:call NextIndent(0, 1, 0, 1)<CR>m'gv''

vnoremap <silent> * :<C-U>
  \ let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \ gvy/<C-R><C-R>=substitute(
  \ escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \ gV:call setreg('"', old_reg, old_regtype)<CR>
