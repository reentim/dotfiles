source ~/.vim/functions.vim

let g:autosave = 1

set nocompatible

set autoindent
set autoread
set backspace=indent,eol,start
set backup
set backupdir=~/.tmp/vimtemp//
set colorcolumn=80
set dir=~/.tmp/vimswap//
set encoding=utf-8
set expandtab
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
set listchars=tab:▸\ ,eol:↵,extends:>,precedes:<,trail:.,space:.
set modeline
set modelines=5
set mouse=a
set nocursorline
set noequalalways
set nofoldenable
set nojoinspaces
set noshowmode
set nowrap
set nu
set re=1 " Use the old vim regex engine for faster syntax highlighting
set ruler
set shell=bash
set shiftwidth=2
set showcmd
set showmatch
set showtabline=2
set smartcase
set smartindent
set softtabstop=2
set splitbelow
set splitright
set t_Co=256
set tabstop=4
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

filetype plugin indent on
syntax on

augroup vimrc
  autocmd!

  autocmd BufLeave,FocusLost * silent! wall
  autocmd BufNewFile,BufRead COMMIT_EDITMSG call AutocmdCommitMessage()
  autocmd BufNewFile,BufRead PULLREQ_EDITMSG call AutocmdPullRequestMessage()
  autocmd BufNewFile,BufRead jrnl*,*journal.txt call SetJournalOptions()
  autocmd BufWritePre,InsertLeave jrnl* call RewrapBuffer()
  autocmd BufNewFile,BufRead * call CdToProjectRoot()
  autocmd BufWritePost functions.vim source ~/.vim/functions.vim
  autocmd BufWritePre,InsertLeave jrnl* call RewrapBuffer()
  autocmd Colorscheme * call Colorscheme_set_after()
  autocmd VimEnter * call VimEnter_after()

  autocmd BufReadPost * call ResumeCursorPosition()
augroup END

augroup vimrc_autosave
  autocmd!

  if exists("g:autosave")
    autocmd InsertLeave,TextChanged * silent! update
  endif
augroup END

let delimitMate_expand_cr = 1
let g:CommandTFileScanner = 'git'
let g:CommandTMatchWindowReverse = 0
let g:CommandTMaxHeight = 20
let g:CommandTMinHeight = 20
let g:CommandTRecursiveMatch = 0
let g:UltiSnipsExpandTrigger = "<C-]>"
let g:UltiSnipsJumpForwardTrigger = "<C-]>"
let g:ackhighlight = 1
let g:ackprg = 'ag --nogroup --nocolor --column'
let g:ale_completion_delay = 50
let g:ale_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_fix_on_save_ignore = {'ruby': ['rubocop']}
let g:ale_fixers = {
      \ 'javascript': ['eslint'],
      \ 'typescript': ['prettier'],
      \ 'html': ['prettier'],
      \ 'css': ['prettier'],
      \ 'ruby': ['rubocop'],
      \}
let g:ale_linters = {
      \ 'typescript': ['tsserver', 'tslint'],
      \ 'javascript': ['eslint']
      \}
let g:ale_pattern_options = {
      \ '.*schema\.rb$': {'ale_enabled': 0},
      \}
let g:ale_sign_column_always = 0
let g:lightline = {
      \ 'active': {
      \   'left': [['mode', 'paste'],
      \             ['readonly', 'relativepath', 'modified']]
      \ },
      \ 'component': {
      \   'lineinfo': ' %3l:%-2v',
      \ },
      \ 'component_function': {
      \   'readonly': 'LightlineReadonly',
      \   'fugitive': 'LightlineFugitive'
      \ },
      \ 'separator': {'left': '', 'right': ''},
      \ 'subseparator': {'left': '', 'right': ''}
      \ }
let g:indent_guides_enable_on_vim_startup = 1
let g:netrw_browse_split = 4
let g:netrw_liststyle = 3
let g:netrw_winsize = 20
let g:splitjoin_ruby_curly_braces = 0
let g:splitjoin_ruby_hanging_args = 0
let g:splitjoin_trailing_comma = 1
let g:tsuquyomi_disable_quickfix = 1
let g:ultisnips_javascript = {
  \ 'keyword-spacing': 'always',
  \ 'semi': 'never',
  \ 'space-before-function-paren': 'always',
\ }
let g:jsx_ext_required = 0
let mapleader = ','

cnoreabbrev <expr> rr AbbrevRemapRun()
cnoreabbrev Ag Ack
cnoreabbrev alefix ALEFix
cnoremap %% <C-r>=expand('%:.:h').'/'<CR>
inoremap <C-J> ->
inoremap <C-L> =><space>
inoremap jk <ESC>
nnoremap / /\v
nnoremap ; :
nnoremap <C-g> :call SelectaIdentifier()<CR>
nnoremap <F5> :set invlist<CR>
" F6 could be the key to, maybe progressively, show / hide all the hidden stuff on the left, including ALE signcolumn
nnoremap <F6> :call LineNumbers_toggle()<CR>
nnoremap <leader>. :call OpenAlternateFile(expand('%'))<CR>
nnoremap <leader>8l :call FullUnderline('-')<CR>
nnoremap <leader>8u :call FullUnderline('=')<CR>
nnoremap <leader><leader> <C-^>
nnoremap <leader>ad :ALEDisable<CR>
nnoremap <leader>ae :ALEEnable<CR>
nnoremap <leader>b :call FuzzyFindBuffer()<CR>
nnoremap <leader>c :call Profile_fuzzy_set()<CR>
nnoremap <leader>d :call AsyncShell('open ' . expand('%:p:h'))<CR>
nnoremap <silent><leader>dd :execute 'read !date "+\%F \%R"'<CR>
nnoremap <leader>ed :lcd ~/deps\|:e common.rb<CR>
nnoremap <leader>ef :e ~/dotfiles/vim/functions.vim<CR>
nnoremap <leader>ep :e ~/dotfiles/profile<CR>
nnoremap <leader>er :source $MYVIMRC\|:call VimEnter_after()<CR>
nnoremap <leader>es :UltiSnipsEdit!<CR>
nnoremap <leader>et :e ~/dotfiles/tmux.conf<CR>
nnoremap <leader>ev :e ~/dotfiles/vimrc<CR>
nnoremap <leader>ez :e ~/dotfiles/zshrc<CR>
nnoremap <leader>ezf :e ~/dotfiles/zsh/functions.zsh<CR>
nnoremap <leader>f :call RunFile()<CR>
nnoremap <leader>gb :call SelectaGitCurrentBranchFile()<CR>
nnoremap <leader>gc :call SelectaGitCommitFile("HEAD")<CR>
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
nnoremap <leader>z :call RunFile({"postfix": ":" . line(".")})<CR>
nnoremap <silent> <CR> :nohl<CR>
nnoremap <silent> [L :call NextIndent(0, 0, 1, 1)<CR>
nnoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
nnoremap <silent> ]L :call NextIndent(0, 1, 1, 1)<CR>
nnoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
nnoremap Y y$
nnoremap [a :ALEPrevious<CR>
nnoremap \ :call RunSavedCommand()<CR>
nnoremap ]a :ALENext<CR>
onoremap <silent> [L :call NextIndent(1, 0, 1, 1)<CR>
onoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
onoremap <silent> ]L :call NextIndent(1, 1, 1, 1)<CR>
onoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
vnoremap / /\v
vnoremap <silent> * :<C-u>
      \ let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
      \ gvy/<C-r><C-r>=substitute(
      \ escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
      \ gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> [L <Esc>:call NextIndent(0, 0, 1, 1)<CR>m'gv''
vnoremap <silent> [l <Esc>:call NextIndent(0, 0, 0, 1)<CR>m'gv''
vnoremap <silent> ]L <Esc>:call NextIndent(0, 1, 1, 1)<CR>m'gv''
vnoremap <silent> ]l <Esc>:call NextIndent(0, 1, 0, 1)<CR>m'gv''
