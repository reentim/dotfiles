" General
" ==============================================================================
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

  " Actual preferences
    set autoread
    set mouse=a
    set ttymouse=xterm2 " better selection and dragging, especially inside tmux
    set showmatch
    set nowrap
    set textwidth=80
    set colorcolumn=80
    set splitright
    let mapleader = ","

  " Pathogen
    call pathogen#infect()
    call pathogen#helptags()

  " Load functions
    if filereadable(expand("~/.vim/functions.vim"))
      source ~/.vim/functions.vim
    endif

    set wildignore+=public/css/**
    set wildignore+=public/assets/**
    set wildignore+=node_modules/**
    set wildignore+=bower_components/**
    set wildignore+=tmp/**,log/**
    set wildignore+=_site/**
    set wildignore+=*.png,*.jpg,*.gif
    set wildignore+=*.doc,*.docx,*.xls,*.xlsx,*.rtf,*.pdf
    set wildignore+=*.mp3,*.mp4,*.mkv,*.avi,*.zip,*.rar,*.iso,*.dmg,*.gz

" Aesthetics
" ==============================================================================
  set nu
  set wildmenu
  set ruler
  set laststatus=2
  set t_Co=256

  if ItermProfile() =~ 'Solarized'
    colorscheme solarized

    if ItermProfile() =~ 'Light'
      set background=light
    else
      set background=dark
    endif
  else
    colorscheme Tomorrow-Night-Bright
  endif

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
    if &term =~ "italic"
        highlight Comment cterm=italic
    endif

" Filetype dependent formatting
" ==============================================================================
  filetype plugin indent on
  set autoindent
  set smartindent
  set expandtab tabstop=2 softtabstop=2 shiftwidth=2

  autocmd BufNewFile,BufRead COMMIT_EDITMSG setlocal textwidth=72
  autocmd BufNewFile,BufRead COMMIT_EDITMSG setlocal colorcolumn=72

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
      autocmd BufNewFile,BufRead *.tpl.php       setlocal spell
      autocmd BufNewFile,BufRead html            setlocal spell
    endif

  " jrnl journaling tool
  autocmd BufNewFile,BufRead jrnl*
    \ setlocal filetype=text wrap linebreak breakat-=@ textwidth=0 spell nonu
  autocmd BufNewFile,BufRead jrnl* nnoremap <buffer> j gj
  autocmd BufNewFile,BufRead jrnl* nnoremap <buffer> k gk

" Plugins
" ==============================================================================
  " Surround
    " with method: ascii 'm'
      autocmd FileType javascript let b:surround_109 = "function() { \r }"
      autocmd FileType ruby       let b:surround_109 = "def \r end"

    " with if: ascii 'i'
      autocmd FileType javascript let b:surround_105 = "if () { \r }"
      autocmd FileType ruby       let b:surround_105 = "if \r end"

  " Syntastic
    let g:syntastic_mode_map = { 'mode': 'passive' }

  " indent html
    let g:html_indent_inctags = "html,body,head,tbody,p,li,label"
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

  " Selecta replaces CommandT
    nnoremap <leader>t :call SelectaFile(".")<cr>
    nnoremap <leader>gv :call SelectaFile("app/views")<cr>
    nnoremap <leader>gc :call SelectaFile("app/controllers")<cr>
    nnoremap <leader>gm :call SelectaFile("app/models")<cr>
    nnoremap <leader>gh :call SelectaFile("app/helpers")<cr>
    nnoremap <leader>gl :call SelectaFile("lib")<cr>
    nnoremap <leader>gp :call SelectaFile("public")<cr>
    nnoremap <leader>gs :call SelectaFile("app/assets/stylesheets")<cr>
    nnoremap <leader>gj :call SelectaFile("app/assets/javascripts")<cr>
    nnoremap <leader>gf :call SelectaFile("features")<cr>

    " Fuzzy select a buffer. Open the selected buffer with :b.
    nnoremap <leader>b :call SelectaBuffer()<cr>

  " Ctrl-P
    let g:ctrlp_working_path_mode = ''
    let g:ctrlp_prompt_mappings = {
      \ 'PrtSelectMove("j")':   ['<c-j>', '<down>', '<c-n>'],
      \ 'PrtSelectMove("k")':   ['<c-k>', '<up>', '<c-p>'],
      \ 'PrtHistory(-1)':       [],
      \ 'PrtHistory(1)':        [],
      \ }
    let g:ctrlp_user_command = [
      \ '.git', 'cd %s && git ls-files . -co --exclude-standard',
      \ 'find %s -type f'
    \ ]
    let g:ctrlp_use_caching = 0

  " Ultisnips
    let g:UltiSnipsExpandTrigger      = "<C-]>"
    let g:UltiSnipsJumpForwardTrigger = "<C-]>"

    autocmd FileType javascript :UltiSnipsAddFiletypes javascript-ember
    autocmd FileType javascript :UltiSnipsAddFiletypes javascript-jasmine-arrow
    autocmd FileType javascript :UltiSnipsAddFiletypes javascript-jasmine
    autocmd FileType javascript :UltiSnipsAddFiletypes javascript-node

  " coffee-script
    highlight link coffeeSpaceError NONE

  " " YouCompleteMe
  "   let g:ycm_collect_identifiers_from_tags_files = 1
  "   let g:ycm_seed_identifiers_with_syntax = 1

  " Ack - use Ag
  let g:ackprg = 'ag --nogroup --nocolor --column'
  cabbrev Ag Ack

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
  " Edit vim-related files
    nnoremap <leader>ev :e $MYVIMRC<CR>
    nnoremap <leader>ef :e ~/.vim/functions.vim<CR>

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
    cabbrev Rspec :!clear && bundle exec rspec %

  " Load Ruby into irb session
    autocmd FileType rb,ruby nnoremap <buffer> <leader>a :w\|:!clear && irb -r %:p<CR>

  " Split HTML attributes
    nnoremap <leader>S :silent! call SplitHTMLAttrs()<CR>

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

  " Copy the last yanked register to host
  vnoremap <leader>c :call CopyToHost()<CR>

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

    " text-object based on matchit matching
    vnoremap ac :<C-U>silent! normal! V<C-U>call <SNR>51_Match_wrapper('',1,'v') <CR>m'gv``
    onoremap ac :normal Vaf<CR>

    " Search for conflict markers
    nnoremap <leader>m /\v^(\<\<\<\<\<\<\<(.*)\|\=\=\=\=\=\=\=\|\>\>\>\>\>\>\>(.*))<CR>

    command! BD :call DeleteInactiveBufs()
    command! Bd :call CloseBuffer()
    cnoreabbrev bd Bd
    cnoreabbrev Bd BD

    cnoreabbrev git Git
