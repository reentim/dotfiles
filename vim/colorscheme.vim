function! Colorscheme_get()
  if exists("g:colors_name")
    return g:colors_name
  else
    echom "No colorscheme found. Falling back to `default`."
    return "default"
  endif
endfunction

function! Colorscheme_set(...)
  let options = get(a:000, 0, {})
  let profile = get(l:options, 'profile')
  let scheme = get(l:options, 'scheme', Colorscheme_for_profile(l:profile))
  execute "colorscheme " . l:scheme
  call Colorscheme_set_after(l:scheme)
endfunction

function! Colorscheme_for_profile(...)
  if $TERM_PROGRAM =~ 'Apple_Terminal'
    return 'Tomorrow-Night-Bright'
  else
    let profile = get(a:000, 0, ItermProfile())
    if l:profile == 0
      let profile = ItermProfile()
    endif

    if profile =~ 'Solarized'
      if profile =~ 'Light'
        set background=light
      elseif profile =~ 'Dark'
        set background=dark
      endif
      return 'solarized'
    elseif profile =~ 'iceberg'
      return 'iceberg'
    else
      return 'Tomorrow-Night-Bright'
    endif
  endif
endfunction

function! Colorscheme_set_after(...)
  let scheme = get(a:000, 0, Colorscheme_get())
  call Lightline_determine_colorscheme(l:scheme)
  call Lightline_update()
  call IndentGuideColors_set()
endfunction

function! Profile_fuzzy_find()
  call Profile_change(SelectaCommand("iterm list_profiles"))
endfunction
