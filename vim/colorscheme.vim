function! Colorscheme_get()
  if exists("g:colors_name")
    return g:colors_name
  else
    echom "No colorscheme found. Falling back to `default`."
    return "default"
  endif
endfunction

function! Colorscheme_detect()
  if $TERM_PROGRAM =~ 'Apple_Terminal'
    let scheme = 'Tomorrow-Night-Bright'
  else
    let profile = ItermProfile()
    if profile =~ 'Solarized'
      if profile =~ 'Light'
        set background=light
      else
        set background=dark
      endif
      let scheme = 'solarized'
    elseif profile =~ 'iceberg'
      let scheme = 'iceberg'
    else
      let scheme = 'Tomorrow-Night-Bright'
    endif
  endif
  execute "colorscheme " . l:scheme
  call Colorscheme_set_after(l:scheme)
endfunction

function! Colorscheme_set_after(...)
  let scheme = get(a:000, 0, Colorscheme_get())
  call Lightline_determine_colorscheme(l:scheme)
  call Lightline_update()
  call IndentGuideColors_set()
endfunction
