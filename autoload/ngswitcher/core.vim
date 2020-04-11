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

let &cpo = s:save_cpo
unlet s:save_cpo
