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
    syntax on

  " Actual preferences
    set nonumber
    set wildmenu
    set ruler
    set sidescrolloff=15
    set scrolloff=2
    set autoread
    set iskeyword-=_ " underscore delimits word boundaries
    set mouse=a
    set ttymouse=xterm2 " better selection and dragging, especially inside tmux
    set showmatch
    let mapleader = ","

  " Pathogen
    call pathogen#infect()
    call pathogen#helptags()

  " Load functions
    if filereadable(expand("~/.vim/functions.vim"))
      source ~/.vim/functions.vim
    endif

" Aesthetics
" ==============================================================================
  set t_Co=256
  set colorcolumn=80
  set nowrap
  set textwidth=80
  colorscheme solarized
  set background=light

  " Highlight trailing whitespace, but not during insertion
    highlight TrailingWhitespace ctermbg=red guibg=red
    au BufEnter    * match TrailingWhitespace /\s\+$/
    au InsertEnter * match TrailingWhitespace /\s\+\%#\@<!$/
    au InsertLeave * match TrailingWhitespace /\s\+$/
    au BufWinLeave * call clearmatches()

  " Italic comments. This requires a terminal emulator that supports italic
  " text, e.g. iTerm2 with setting enabled, and an appropriate TERMINFO (see
  " https://gist.github.com/sos4nt/3187620).
  " If echo `tput sitm`italics`tput ritm` produces italic text, then this should
  " work (maybe)
    highlight Comment cterm=italic

" Filetype dependent formatting
" ==============================================================================
  filetype plugin indent on
  set autoindent
  set smartindent

  set expandtab tabstop=2 softtabstop=2 shiftwidth=2

  autocmd FileType php,c,sh
    \ setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab

  autocmd FileType gitcommit let b:noResumeCursorPosition=1

  " Spell-checking
    if has('spell')
      set spell
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

" Searching
" ==============================================================================
  set hlsearch
  execute ":nohlsearch"
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
    nnoremap <leader>ev :e ~/.dotfiles/vimrc<CR>

  " Reload .vimrc
    nnoremap <leader>er :source ~/.dotfiles/vimrc<CR>

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

  " Shortcut to invoke watch / browser refresh script in background...
    let g:watching = 0
    nnoremap <leader>c :call SetWatch()<CR><CR>
    " ...and tidy up afterwards
    autocmd VimLeave * :call RemoveWatch()

  " Paste mode
    nnoremap <leader>p :set invpaste<CR>

  " Underlining, relies on vim-commentary plugin
  " ----------------------------------------------------
    nnoremap <leader>l :call Underline('-')<CR>
    nnoremap <leader>u :call Underline('=')<CR>

  " 80 character '=' underline
    nmap <leader>8 yypd$aa<ESC>\\lyypd$80a=<ESC>:norm 80\|<CR>d$khljd^\\lkddk

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

  " When Vim opens, jump to last cursor position
    autocmd BufReadPost * call ResumeCursorPosition()

  " Aggressive autosaving
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
  nnoremap <leader><leader> <C-^>

  " :bdelete also closes the current window; let's fix that
    command! Bd bp|sp|bp|bd
    cabbrev bd Bd

  " Make Y consistent with C and D.  See :help Y.
    nnoremap Y y$

  " Get directory of current file
    cnoremap %% <C-R>=expand('%:p:h').'/'<CR>

  " Hash rockets and arrows
    inoremap <c-l> =><space>
    inoremap <c-j> ->

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
