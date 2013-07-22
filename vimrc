" General
" ------------------------------------------------------------------------------
  set nocompatible
  let mapleader = ","
  set backspace=indent,eol,start
  set nonu
  set encoding=utf-8
  set showcmd
  set noshowmode
  set ttyfast
  set ttimeout
  set ttimeoutlen=10
  syntax on
  set shell=bash
  set showmatch
  autocmd BufLeave,FocusLost * silent! wall
  let g:watching = 0
  set tw=79

  " Jump to last cursor position unless it's invalid or in an event handler
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

" Aesthetics
" ------------------------------------------------------------------------------
  set t_Co=256
  set colorcolumn=80
  set ruler
  colorscheme Tomorrow-Night-Bright
  set listchars=tab:▸\ ,eol:↵
  set listchars+=trail:.
  set listchars+=extends:>
  set listchars+=precedes:<
  nmap <F5> :set invlist<CR>

" Filetype dependent formatting
" ----------------------------------------------------------------------------
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
" ------------------------------------------------------------------------------
  " Pathogen
    call pathogen#infect()
    call pathogen#helptags()
    filetype plugin indent on

  " Surround
    " with method: ascii 'm'
      autocmd FileType javascript let b:surround_109 = "function() { \r }"
      autocmd FileType ruby       let b:surround_109 = "def \r end"

    " with if: ascii 'i'
      autocmd FileType javascript let b:surround_105 = "if () { \r }"
      autocmd FileType ruby       let b:surround_105 = "if \r end"

  " Powerline
    set laststatus=2

  " Syntastic
    let g:syntastic_mode_map = { 'mode': 'passive' }

  " indent html
    let g:html_indent_inctags = "html,body,head,tbody"
    let g:html_indent_script1 = "inc"
    let g:html_indent_style1 = "inc"

  " delimitmate
    let delimitMate_offByDefault = 0
    let delimitMate_expand_cr = 1
    let delimitMate_expand_space = 1

  " Indent Guides
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_auto_colors = 0

    " Tomorrow-Night-Eighties
      " hi IndentGuidesOdd  guibg=red   ctermbg=236
      " hi IndentGuidesEven guibg=green ctermbg=238

    " Tomorrow-Night-Bright
      hi IndentGuidesOdd  guibg=red   ctermbg=235
      hi IndentGuidesEven guibg=green ctermbg=237

  " Command-t
    set wildignore+=public/css
    let g:CommandTMaxFiles=99000
    map <leader>t  :wa\|:CommandTFlush<CR>\|:CommandT<CR>
    " let g:CommandTMatchWindowAtTop=1
    let g:CommandTMatchWindowReverse=1
    let g:CommandTClearMap='<C-w>'

  " Ctrl-P
    let g:ctrlp_max_height = 55
    let g:ctrlp_match_window_reversed = 0
    " let g:ctrlp_working_path_mode = ''

  " Ultisnips
    let g:UltiSnipsExpandTrigger      = "<C-]>"
    let g:UltiSnipsJumpForwardTrigger = "<C-]>"
    let g:UltiSnipsSnippetsDir        = "~/.vim/bundle/snippets/UltiSnips"

  " coffee-script
    hi link coffeeSpaceError NONE

" Whitespace
" ------------------------------------------------------------------------------
  set nowrap
  set expandtab tabstop=2 softtabstop=2 shiftwidth=2
  set autoindent
  set smartindent

  highlight TrailingWhitespace ctermbg=red guibg=red
  au BufEnter    * match TrailingWhitespace /\s\+$/
  au InsertEnter * match TrailingWhitespace /\s\+\%#\@<!$/
  au InsertLeave * match TrailingWhitespace /\s\+$/
  au BufWinLeave * call clearmatches()

  " highlight ErrantIndentStyle ctermbg=red guibg=red
  " au BufEnter    * match ErrantIndentStyle /  /
  " au InsertEnter * match ErrantIndentStyle /  /
  " au InsertLeave * match ErrantIndentStyle /  /

" Searching
" ------------------------------------------------------------------------------
  set hlsearch
  set incsearch
  set ignorecase
  set smartcase
  nnoremap <CR> :nohlsearch<CR>

  " Search for selected text, forwards or backwards.
  " ------------------------------------------------
    vnoremap <silent> * :<C-U>
       \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
       \gvy/<C-R><C-R>=substitute(
       \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
       \gV:call setreg('"', old_reg, old_regtype)<CR>

  " Standardise regex handling
  " --------------------------
    nnoremap / /\v
    vnoremap / /\v

" Leader shortcuts
" ------------------------------------------------------------------------------
  " Paste mode
    nnoremap <leader>p :set invpaste<CR>

    " open current file / directory in MacOS
    nnoremap <leader>o :!open %<CR><CR>
    nnoremap <leader>d :!open <C-R>=expand('%:p:h').'/'<CR><CR>

    " Agressive autosave mode
    nnoremap <leader>a :call AutoSaveMode()<CR>
    function! AutoSaveMode()
      autocmd InsertLeave <buffer> update
      autocmd CursorMoved <buffer> update
    endfunction

    autocmd InsertLeave * silent! update
    autocmd CursorMoved * silent! update

    function! SplitHTMLAttrs()
      normal 0dw
      :s/ /\r/g

      " fix indentation, for self closing tags, will indent parent and move
      " cursor...
      normal vat=

      " ...so move it back
      normal `._
    endfunction
    nnoremap <leader>S :call SplitHTMLAttrs()<CR>

  " Shortcut to invoke watch / browser refresh script in background...
  " ------------------------------------------------------------------
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

    nnoremap <leader>q :!coffee --compile %<CR><CR>

  " Run scripts
    autocmd FileType sh,bash    nnoremap <leader>r :w\|:!clear && time bash %:p<CR>
    autocmd FileType rb,ruby    nnoremap <leader>r :w\|:!clear && time ruby %:p<CR>
    autocmd FileType py,python  nnoremap <leader>r :w\|:!clear && time python %:p<CR>
    autocmd FileType javascript nnoremap <leader>r :w\|:!clear && time node %:p<CR>
    autocmd FileType c          nnoremap <leader>r :w\|:silent! !gcc %:p<CR>:!time ./a.out<CR>
    autocmd FileType vim        nnoremap <leader>r :w\|:source %:p<CR>

  " Run tests / specs
    nnoremap <leader>f :wa\|:!clear && time bundle exec rspec --color --tty  --format documentation %<CR>
    nnoremap <leader>z :wa\|:!clear && time zeus rspec --color --tty  --format documentation %<CR>

  " load rb into irb session
    autocmd FileType rb,ruby    nnoremap <leader>a :!clear<CR>:w\|:!irb -r %:p<CR>

  " Reselect pasted text: <,v>
    nnoremap <leader>v V`]
    nnoremap <leader>v V`]

  " Edit .vimrc in new vertical window
    nnoremap <leader>ev :e $MYVIMRC<CR>

  " Edit snippets
    nnoremap <leader>es :execute "e ~/.vim/bundle/snippets/UltiSnips/" . &filetype . ".snippets"<CR>

  " Comment underlining: relies on vim-commentary plugin
  " ----------------------------------------------------
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
    nnoremap <leader>l :call UnderlineComment()<CR>

    " 80 character underline
    " ----------------------
      nmap <leader>8 yypd$aa<ESC>\\lyypd$80a-<ESC>:norm 80\|<CR>d$khljd^\\lkddk

" Folding
" ------------------------------------------------------------------------------
  set foldmethod=indent
  set nofoldenable

" Buffers and windows
" ------------------------------------------------------------------------------
  set hidden

  " switch to new split window
    nnoremap <leader>w <C-w>v<C-w>l
    nnoremap <leader>h :split<CR><C-w>j

  " moving around windows
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l

" Central temporary directories
" ------------------------------------------------------------------------------
  set backup
  set backupdir=/tmp/vimtemp//
  set dir=/tmp/vimswap//
  set undofile
  set undodir=/tmp/vimundo//

" General custom mappings
" ------------------------------------------------------------------------------
  nnoremap ; :
  inoremap jk <ESC>
  nnoremap <leader><leader> <c-^>

  " :bdelete also closes the current window; let's fix that
  command! Bd bp|sp|bn|bd
  cabbrev bd Bd

  " Make Y consistent with C and D.  See :help Y.
    nnoremap Y y$

  " Get directory of current file
  " ---------------------------------------
    cnoremap %% <C-R>=expand('%:p:h').'/'<CR>

  " hash rockets and arrows
    imap <c-l> =><space>
    imap <c-j> ->
