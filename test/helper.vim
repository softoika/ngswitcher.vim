function! Path(path) abort
  if has('win32') || has('win64')
    return substitute(a:path, '/', '\', 'g')
  endif
  return a:path
endfunction

