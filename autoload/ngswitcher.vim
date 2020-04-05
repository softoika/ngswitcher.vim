let s:save_cpo = &cpo
set cpo&vim

let s:errorPrefix = 'ngswitcher: '
let s:factory = core#angular_file#getFactory()

function! ngswitcher#getTSPath(currentFile, ...) abort
  let default = get(a:, 1, '.html')
  if a:currentFile.isTS()
    if exists('s:previousFile') && s:previousFile.hasDefinedExtension()
      return s:previousFile.path
    else 
      return a:currentFile.directory . '/' . a:currentFile.name . default
    endif
  else
    return a:currentFile.directory . '/' . a:currentFile.name . '.ts'
  endif
endfunction

function! ngswitcher#openTSFile(currentFilePath) abort
  let currentFile = s:factory.create(a:currentFilePath)
  if !currentFile.hasDefinedExtension()
   " do nothing
    return
  endif
  let nextPath = ngswitcher#getTSPath(currentFile)
  if filereadable(nextPath)
    execute 'e ' . nextPath
    let s:previousFile = currentFile
  else
    throw s:errorPrefix . nextPath . ' does not exist.'
  endif
endfunction

function! ngswitcher#clearHistory() abort
  unlet s:previousFile
endfunction
