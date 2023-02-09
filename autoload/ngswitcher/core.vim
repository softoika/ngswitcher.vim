let s:save_cpo = &cpo
set cpo&vim

let s:AngularFile = {}

function! s:AngularFile._isSameName(other) abort
  let selfName = get(self, 'name', '')
  let otherName = get(a:other, 'name', '')
  if selfName == '' || otherName == ''
    return 0
  endif
  return selfName ==# otherName
endfunction

function! s:AngularFile._isSameDirectory(other) abort
  let selfDirectory = get(self, 'directory', '')
  let otherDirectory = get(a:other, 'directory', '')
  if selfDirectory == '' || otherDirectory == ''
    return 0
  endif
  return selfDirectory ==# otherDirectory
endfunction

" The funtion name is isSameComponent, but the target file is not limited to
" an Angular component (such as a service)
function! s:AngularFile.isSameComponent(other) abort
  return self._isSameDirectory(a:other) && self._isSameName(a:other)
endfunction

let s:ExtensionType = {
\ 'ts': 'ts',
\ 'html': 'html',
\ 'spec.ts': 'spec',
\ 'test.ts': 'spec',
\ 'css': 'css',
\ 'scss': 'css',
\ 'sass': 'css',
\ 'less': 'css',
\ 'stylus': 'css',
\ 'styl': 'css'
\ }

function! s:AngularFile.isTS() abort
  let extension = tolower(get(self, 'extension', ''))
  return has_key(s:ExtensionType, extension) && s:ExtensionType[extension] == 'ts'
endfunction

function! s:AngularFile.isHTML() abort
  let extension = tolower(get(self, 'extension', ''))
  return has_key(s:ExtensionType, extension) && s:ExtensionType[extension] == 'html'
endfunction

function! s:AngularFile.isSpec() abort
  let extension = tolower(get(self, 'extension', ''))
  return has_key(s:ExtensionType, extension) && s:ExtensionType[extension] == 'spec'
endfunction

function! s:AngularFile.isCSS() abort
  let extension = tolower(get(self, 'extension', ''))
  return has_key(s:ExtensionType, extension) && s:ExtensionType[extension] == 'css'
endfunction

function! s:AngularFile.hasDefinedExtension() abort
  let extension = tolower(get(self, 'extension', ''))
  return has_key(s:ExtensionType, extension)
endfunction

let s:AngularFileFactory = {}

function! s:AngularFileFactory.create(filePath) abort
  let ngFile = deepcopy(s:AngularFile)
  if a:filePath =~? '\.spec\.ts$'
    let ngFile.name = fnamemodify(a:filePath, ':t:r:r')
    let ngFile.extension = fnamemodify(a:filePath, ':e:e')
  elseif a:filePath =~? '\.test\.ts$'
    let ngFile.name = fnamemodify(a:filePath, ':t:r:r')
    let ngFile.extension = fnamemodify(a:filePath, ':e:e')
  else
    let ngFile.name = fnamemodify(a:filePath, ':t:r')
    let ngFile.extension = fnamemodify(a:filePath, ':e')
  endif
  let ngFile.directory = fnamemodify(a:filePath, ':h')
  let ngFile.path = a:filePath
  return ngFile
endfunction

function! ngswitcher#core#getAngularFileFactory()
  return s:AngularFileFactory
endfunction

let s:Component = {}

function! s:Component.hasHTML() abort
  return has_key(self, 'htmlFile')
endfunction

function! s:Component.hasCSS() abort
  return has_key(self, 'cssFile')
endfunction

function! s:Component.hasTS() abort
  return has_key(self, 'tsFile')
endfunction

function! s:Component.hasSpec() abort
  return has_key(self, 'specFile')
endfunction

function! s:Component.getHTML() abort
  return get(self, 'htmlFile')
endfunction

function! s:Component.getCSS() abort
  return get(self, 'cssFile')
endfunction

function! s:Component.getTS() abort
  return get(self, 'tsFile')
endfunction

function! s:Component.getSpec() abort
  return get(self, 'specFile')
endfunction

function! s:Component.getCurrentFile() abort
  return get(self, 'currentFile')
endfunction

let s:ComponentFactory = {}

function! s:ComponentFactory.create(currentPath, filePaths) abort
  let component = deepcopy(s:Component)
  let currentFile = s:AngularFileFactory.create(a:currentPath)
  if currentFile.hasDefinedExtension()
    let component.currentFile = currentFile
  else 
    throw 'ngswitcher: Not available from ' . a:currentFile
  endif
  let files = map(copy(a:filePaths), 's:AngularFileFactory.create(v:val)')
  let files = filter(copy(files), 'v:val.hasDefinedExtension()')
  let files = filter(copy(files), 'v:val.isSameComponent(currentFile)')
  for file in files
    if file.isHTML()
      let component.htmlFile = file
    elseif file.isCSS()
      let component.cssFile = file
    elseif file.isTS()
      let component.tsFile = file
    elseif file.isSpec()
      let component.specFile = file
    endif
  endfor
  return component
endfunction

function! ngswitcher#core#getComponentFactory()
  return s:ComponentFactory
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
