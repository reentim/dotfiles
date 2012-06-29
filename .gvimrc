" Appearance
" ------------------------------------------------------------------------------
	set guifont=Inconsolata:h13
	colorscheme darkblue
	set cursorline
	hi CursorLine
	IndentGuidesEnable
	set colorcolumn=80
	highlight ColorColumn guibg=#303050

	" Disable window chrome
	" --------------------------------------------------------------------------
		set guioptions-=T " don't show toolbar
		set guioptions-=r " don't show scrollbars
		set guioptions-=l " don't show scrollbars
		set guioptions-=R " don't show scrollbars
		set guioptions-=L " don't show scrollbars

" Behaviour
" ------------------------------------------------------------------------------
	autocmd BufLeave,FocusLost * silent! wall
	set vb " use (nonexistent) visual bell instead of audio
