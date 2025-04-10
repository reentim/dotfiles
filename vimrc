set nocompatible

let mapleader = ','

if filereadable(expand("~/.vim/functions.vim"))
  source ~/.vim/functions.vim
endif

if filereadable(expand("~/.vimrc.common"))
  source ~/.vimrc.common
endif

set autoindent
set autoread
set backspace=indent,eol,start
set backupdir=/tmp/vimtemp//
set dir=/tmp/vimswap//
set encoding=utf-8
set fileencoding=utf-8
set grepprg=ag\ --vimgrep\ $*
set history=10000
set hlsearch
set incsearch
set laststatus=2
set listchars=tab:▸\ ,eol:↵,extends:>,precedes:<,trail:.,space:.
set mouse=a
set shell=bash
set showcmd
set t_Co=256
set ttimeout
set ttyfast
set ttymouse=sgr
set undodir=/tmp/vimundo//
set wildignore+=*node_modules*
set wildmenu

filetype plugin indent on
syntax on

augroup vimrc
  autocmd!

  autocmd Colorscheme * call Colorscheme_set_after()
  autocmd VimEnter * call VimEnter_after()
augroup END

let delimitMate_expand_cr = 1
let g:CommandTPreferredImplementation='ruby'
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
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
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
let g:indent_guides_enable_on_vim_startup = 0
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

" nnoremap \ :call RunSavedCommand()<CR>
cnoreabbrev <expr> rr AbbrevRemapRun()
cnoreabbrev Ag Ack
cnoreabbrev alefix ALEFix
nnoremap <C-g> :call SelectaIdentifier()<CR>
nnoremap <leader>. :call OpenAlternateFile(expand('%'))<CR>
nnoremap <leader>8l :call FullUnderline('-')<CR>
nnoremap <leader>8u :call FullUnderline('=')<CR>
nnoremap <leader>ad :ALEDisable<CR>
nnoremap <leader>ae :ALEEnable<CR>
nnoremap <leader>b :call FuzzyFindBuffer()<CR>
nnoremap <leader>d :call AsyncShell('open ' . expand('%:p:h'))<CR>
nnoremap <leader>ef :e ~/dotfiles/vim/functions.vim<CR>
nnoremap <leader>er :source $MYVIMRC\|:call VimEnter_after()<CR>
nnoremap <leader>es :UltiSnipsEdit!<CR>
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
nnoremap <leader>lp :call GitLogPatch()<CR>
nnoremap <leader>n :call RenameFile()<CR>
nnoremap <leader>o :!open %<CR><CR>
nnoremap <leader>r :call RunFile()<CR>
nnoremap <leader>t :call FuzzyFind(".")<CR>
nnoremap <leader>u :call Underline('=')<CR>
nnoremap <leader>z :call RunFile({"postfix": ":" . line(".")})<CR>
nnoremap <silent> [L :call NextIndent(0, 0, 1, 1)<CR>
nnoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
nnoremap <silent> ]L :call NextIndent(0, 1, 1, 1)<CR>
nnoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
nnoremap [a :ALEPrevious<CR>
nnoremap ]a :ALENext<CR>
onoremap <silent> [L :call NextIndent(1, 0, 1, 1)<CR>
onoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
onoremap <silent> ]L :call NextIndent(1, 1, 1, 1)<CR>
onoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
vnoremap <silent> * :<C-u>
      \ let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
      \ gvy/<C-r><C-r>=substitute(
      \ escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
      \ gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> [L <Esc>:call NextIndent(0, 0, 1, 1)<CR>m'gv''
vnoremap <silent> [l <Esc>:call NextIndent(0, 0, 0, 1)<CR>m'gv''
vnoremap <silent> ]L <Esc>:call NextIndent(0, 1, 1, 1)<CR>m'gv''
vnoremap <silent> ]l <Esc>:call NextIndent(0, 1, 0, 1)<CR>m'gv''
