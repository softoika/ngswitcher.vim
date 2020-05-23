let s:save_cpo = &cpo
set cpo&vim

let s:componentFactory = ngswitcher#core#getComponentFactory()

function! ngswitcher#toTS(component) abort
  let currentFile = a:component.getCurrentFile()
  if currentFile.isTS()
    if exists('s:previousFile') && s:previousFile.isSameComponent(a:currentFile)
      return s:previousFile.path
    else
      if a:component.hasHTML()
        return a:component.getHTML().path
      elseif a:component.hasSpec()
        return a:component.getSpec().path
      else
        return currentFile.path
      endif
    endif
  else
    if a:component.hasTS()
      return a:component.getTS().path
    else
      throw 'ngswitcher: The target ts file is not exist.'
    endif
  endif
endfunction

function! ngswitcher#toCSS(component) abort
  let currentFile = a:component.getCurrentFile()
  if currentFile.isCSS()
    if exists('s:previousFile') && s:previousFile.isSameComponent(currentFile)
      return s:previousFile.path
    else
      if a:component.hasHTML()
        return a:component.getHTML().path
      else
        return currentFile.path
      endif
    endif
  else
    if a:component.hasCSS()
      return a:component.getCSS().path
    else
      throw 'ngswitcher: The target css file is not exist.'
    endif
  endif
endfunction

function! ngswitcher#toHTML(component) abort
  let currentFile = a:component.getCurrentFile()
  if currentFile.isHTML()
    if exists('s:previousFile') && s:previousFile.isSameComponent(currentFile)
      return s:previousFile.path
    else 
      if a:component.hasTS()
        return a:component.getTS().path
      else
        return currentFile.path
      endif
    endif
  else
    if a:component.hasHTML()
      return a:component.getHTML().path
    else
      throw 'ngswitcher: The target html file is not exist.'
    endif
  endif
endfunction

function! ngswitcher#toSpec(component) abort
  let currentFile = a:component.getCurrentFile()
  if currentFile.isSpec()
    if exists('s:previousFile') && s:previousFile.isSameComponent(currentFile)
      return s:previousFile.path
    else 
      if a:component.hasTS()
        return a:component.getTS().path
      else
        return currentFile.path
      endif
    endif
  else
    if a:component.hasSpec()
      return a:component.getSpec().path
    else
      throw 'ngswitcher: The target spec file is not exist.'
    endif
  endif
endfunction

" The argument of toFileFunc is a Funcref such as ngswitcher#toTS().
" Example of usage: call ngswitcher#switch(function('ngswitcher#toTS'))
function! ngswitcher#switch(toFileFunc) abort
  let currentPath = expand('%')
  let directory = expand('%:h')
  let filePaths = split(expand(directory . '/*'), '\n')
  try
    let component = s:componentFactory.create(currentPath, filePaths)
    let nextPath = a:toFileFunc(component)
    if filereadable(nextPath)
      execute 'e ' . nextPath
      let s:previousFile = component.getCurrentFile()
    else
      throw 'ngswitcher: ' . nextPath . ' does not exist.'
    endif
  catch
    echohl ErrorMsg
    echomsg v:exception
    echohl None
  endtry
endfunction

function! ngswitcher#clearHistory() abort
  if exists('s:previousFile')
    unlet s:previousFile
  endif
endfunction

function! ngswitcher#showList() abort
  let currentPath = expand('%')
  let directory = expand('%:h')
  let filePaths = split(expand(directory . '/*'), '\n')
  try
    let component = s:componentFactory.create(currentPath, filePaths)
    call ngswitcher#window#showList(component)
  catch
    echohl ErrorMsg
    echomsg v:exception
    echohl None
  endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
