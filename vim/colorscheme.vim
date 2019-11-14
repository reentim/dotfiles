function! Colorscheme_get()
  if exists("g:colors_name")
    return g:colors_name
  else
    return "default"
  endif
endfunction

function! Colorscheme_set(...)
  let options = get(a:000, 0, {})
  let profile = get(l:options, 'profile', Profile_cache_get())
  let scheme = get(l:options, 'scheme', Colorscheme_for_profile(l:profile))
  execute "colorscheme " . l:scheme
  call Colorscheme_set_after({"profile": l:profile, "scheme": l:scheme})
endfunction

function! Colorscheme_background_set(profile, scheme)
  if a:scheme =~ 'Solarized'
    if a:profile =~ 'Light'
      set background=light
    elseif a:profile =~ 'Dark'
      set background=dark
    endif
  endif
endfunction

function! Colorscheme_for_profile(...)
  if $TERM_PROGRAM =~ 'Apple_Terminal'
    return 'Tomorrow-Night-Bright'
  else
    let profile = get(a:000, 0, Profile_cache_get())
    if l:profile =~ 'Solarized'
      return 'solarized'
    elseif profile =~ 'iceberg'
      return 'iceberg'
    else
      return 'Tomorrow-Night-Bright'
    endif
  endif
endfunction

function! Colorscheme_set_after(...)
  let scheme = get(get(a:000, 0, {}), "scheme", Colorscheme_get())
  let profile = get(get(a:000, 0, {}), "profile", Profile_cache_get())
  call Colorscheme_background_set(l:profile, l:scheme)
  call Lightline_determine_colorscheme(l:scheme)
  call Lightline_update()
  call IndentGuideColors_set(IndentGuideColors_get(l:scheme))
  call TrailingWhitespace_highlight()
endfunction
