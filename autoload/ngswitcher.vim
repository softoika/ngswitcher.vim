let s:save_cpo = &cpo
set cpo&vim

let s:errorPrefix = 'ngswitcher: '
let s:factory = ngswitcher#core#getAngularFileFactory()

function! ngswitcher#toTS(currentFile, targetFiles) abort
  if a:currentFile.isTS()
    if exists('s:previousFile') && s:previousFile.isSameComponent(currentFile)
      return s:previousFile.path
    else 
      let targetHTMLFiles = filter(copy(a:targetFiles), 'v:val.isHTML()')
      if len(targetHTMLFiles) > 0
        return targetHTMLFiles[0].path
      endif
      let targetSpecFiles = filter(copy(a:targetFiles), 'v:val.isSpec()')
      if len(targetSpecFiles) > 0
        return targetSpecFiles[0].path
      endif
      return a:currentFile.path
    endif
  else
    let targetTSFiles = filter(copy(a:targetFiles), 'v:val.isTS()')
    if len(targetTSFiles) > 0
      return targetTSFiles[0].path
    else
      throw s:errorPrefix . 'the target ts file is not exist.'
    endif
  endif
endfunction

function! ngswitcher#toCSS(currentFile, targetFiles) abort
  if a:currentFile.isCSS()
    if exists('s:previousFile') && s:previousFile.isSameComponent(currentFile)
      return s:previousFile.path
    else 
      let targetHTMLFiles = filter(copy(a:targetFiles), 'v:val.isHTML()')
      if len(targetHTMLFiles) > 0
        return targetHTMLFiles[0].path
      endif
      return a:currentFile.path
    endif
  else
    let targetCSSFiles = filter(copy(a:targetFiles), 'v:val.isCSS()')
    if len(targetCSSFiles) > 0
      return targetCSSFiles[0].path
    else
      throw s:errorPrefix . 'the target ts file is not exist.'
    endif
  endif
endfunction

function! ngswitcher#toHTML(currentFile, targetFiles) abort
  if a:currentFile.isHTML()
    if exists('s:previousFile') && s:previousFile.isSameComponent(currentFile)
      return s:previousFile.path
    else 
      let targetTSFiles = filter(copy(a:targetFiles), 'v:val.isTS()')
      if len(targetTSFiles) > 0
        return targetTSFiles[0].path
      endif
      return a:currentFile.path
    endif
  else
    let targetHTMLFiles = filter(copy(a:targetFiles), 'v:val.isHTML()')
    if len(targetHTMLFiles) > 0
      return targetHTMLFiles[0].path
    else
      throw s:errorPrefix . 'the target ts file is not exist.'
    endif
  endif
endfunction

function! ngswitcher#toSpec(currentFile, targetFiles) abort
  if a:currentFile.isSpec()
    if exists('s:previousFile') && s:previousFile.isSameComponent(currentFile)
      return s:previousFile.path
    else 
      let targetTSFiles = filter(copy(a:targetFiles), 'v:val.isTS()')
      if len(targetTSFiles) > 0
        return targetTSFiles[0].path
      endif
      return a:currentFile.path
    endif
  else
    let targetSpecFiles = filter(copy(a:targetFiles), 'v:val.isSpec()')
    if len(targetSpecFiles) > 0
      return targetSpecFiles[0].path
    else
      throw s:errorPrefix . 'the target ts file is not exist.'
    endif
  endif
endfunction

" The argument of getFilePathFunc is a Funcref such as ngswitcher#getTSPath().
" Example of usage: call ngswitcher#switch(function('ngswitcher#toTS'))
function! ngswitcher#switch(toFileFunc) abort
  let currentFile = s:factory.create(expand('%'))
  if !currentFile.hasDefinedExtension()
   " do nothing
    return
  endif
  let targetFiles = ngswitcher#getAngularFilesInCurrentDirectory()
  let targetFiles = filter(copy(targetFiles), 'v:val.isSameComponent(currentFile)')
  let nextPath = a:toFileFunc(currentFile, targetFiles)
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
  let files = map(copy(filePaths), 's:factory.create(v:val)')
  return filter(copy(files), 'v:val.hasDefinedExtension()')
endfunction

function! ngswitcher#clearHistory() abort
  if exists('s:previousFile')
    unlet s:previousFile
  endif
endfunction
