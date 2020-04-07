let s:save_cpo = &cpo
set cpo&vim

let s:errorPrefix = 'ngswitcher: '
let s:factory = ngswitcher#core#getAngularFileFactory()

function! ngswitcher#getTSPath(currentFile, targetFiles, ...) abort
  let default = get(a:, 1, '.html')
  if a:currentFile.isTS()
    if exists('s:previousFile') && s:previousFile.isSameComponent(currentFile)
      return s:previousFile.path
    else 
      return a:currentFile.directory . '/' . a:currentFile.name . default
    endif
  else
    let targetTSFiles = filter(a:targetFiles, 'v:val.isTS()')
    if len(targetTSFiles) > 0
      return targetTSFiles[0].path
    else
      throw s:errorPrefix . ' the target ts file is not exist.'
    endif
  endif
endfunction

function! ngswitcher#getCSSPath(currentFile, targetFiles, ...) abort
  let default = get(a:, 1, '.html')
  if a:currentFile.isCSS()
    if exists('s:previousFile') && s:previousFile.isSameComponent(currentFile)
      return s:previousFile.path
    else 
      return a:currentFile.directory . '/' . a:currentFile.name . default
    endif
  else
    let targetCSSFiles = filter(a:targetFiles, 'v:val.isCSS()')
    if len(targetCSSFiles) > 0
      return targetCSSFiles[0].path
    else
      throw s:errorPrefix . ' the target ts file is not exist.'
    endif
  endif
endfunction

function! ngswitcher#getHTMLPath(currentFile, targetFiles, ...) abort
  let default = get(a:, 1, '.ts')
  if a:currentFile.isHTML()
    if exists('s:previousFile') && s:previousFile.isSameComponent(currentFile)
      return s:previousFile.path
    else 
      return a:currentFile.directory . '/' . a:currentFile.name . default
    endif
  else
    let targetHTMLFiles = filter(a:targetFiles, 'v:val.isHTML()')
    if len(targetHTMLFiles) > 0
      return targetHTMLFiles[0].path
    else
      throw s:errorPrefix . ' the target ts file is not exist.'
    endif
  endif
endfunction

function! ngswitcher#getSpecPath(currentFile, targetFiles, ...) abort
  let default = get(a:, 1, '.ts')
  if a:currentFile.isSpec()
    if exists('s:previousFile') && s:previousFile.isSameComponent(currentFile)
      return s:previousFile.path
    else 
      return a:currentFile.directory . '/' . a:currentFile.name . default
    endif
  else
    let targetSpecFiles = filter(a:targetFiles, 'v:val.isSpec()')
    if len(targetSpecFiles) > 0
      return targetSpecFiles[0].path
    else
      throw s:errorPrefix . ' the target ts file is not exist.'
    endif
  endif
endfunction

" The argument of getFilePathFunc is a Funcref such as ngswitcher#getTSPath().
" Example of usage: call ngswitcher#switch(function('ngswitcher#getTSPath'))
function! ngswitcher#switch(getFilePathFunc) abort
  let currentFile = s:factory.create(expand('%'))
  if !currentFile.hasDefinedExtension()
   " do nothing
    return
  endif
  let targetFiles = ngswitcher#getAngularFilesInCurrentDirectory()
  let nextPath = a:getFilePathFunc(currentFile, targetFiles)
  if filereadable(nextPath)
    execute 'e ' . nextPath
    let s:previousFile = currentFile
  else
    throw s:errorPrefix . nextPath . ' does not exist.'
  endif
endfunction

function! ngswitcher#getAngularFilesInCurrentDirectory() abort
  let directory = expand('%:h')
  let filePaths = split(expand(directory . '/*'), '\n')
  let files = map(filePaths, 's:factory.create(v:val)')
  return filter(files, 'v:val.hasDefinedExtension()')
endfunction

function! ngswitcher#clearHistory() abort
  if exists('s:previousFile')
    unlet s:previousFile
  endif
endfunction
