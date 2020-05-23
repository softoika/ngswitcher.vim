let s:save_cpo = &cpo
set cpo&vim

let g:ngswitcher_list_shortcut_key_ts = 'u'
let g:ngswitcher_list_shortcut_key_css = 'i'
let g:ngswitcher_list_shortcut_key_html = 'o'
let g:ngswitcher_list_shortcut_key_spec = 'p'

function! ngswitcher#window#showList(component) abort
  if has('popupwin')
    call s:openPopupWindow(a:component)
  " elseif exists('nvim_open_win')
  else
    throw 'ngswitcher: This feature is only available on vim 8.1 or later'
  endif
endfunction

function! s:openPopupWindow(component) abort
  if len(prop_type_get('currentLine')) == 0
    call prop_type_add('currentLine', {'highlight': 'PmenuSel'})
  endif
  let window = s:WindowFactory.create(a:component)
  let winId = popup_create(window.textLines, #{
        \ pos: 'center',
        \ mapping: 0,
        \ padding: [1, 2, 1, 2],
        \ filter: function('s:popupFilter', [window]),
        \ callback: function('s:onPopupClose')
        \ })
  call s:updateHighlight(window, winId)
endfunction


function! s:popupFilter(window, winId, key) abort
  if a:key ==# 'x' || a:key ==# 'q' || a:key ==# "\<Esc>" || a:key ==# "\<C-C>"
    call popup_close(a:winId)
    return 1
  endif
  if a:key ==# 'j' || a:key ==# "\<Down>" || a:key ==# "\<C-N>"
    call a:window.moveDown()
    call s:updateHighlight(a:window, a:winId)
    return 1
  endif
  if a:key ==# 'k' || a:key ==# "\<Up>" || a:key ==# "\<C-P>"
    call a:window.moveUp()
    call s:updateHighlight(a:window, a:winId)
    return 1
  endif
  if a:key ==# "\<CR>" || a:key ==# "\<LF>"
    let file = a:window.getFileOnCursor()
    call popup_close(a:winId, file.path)
    return 1
  endif
  if a:key ==# g:ngswitcher_list_shortcut_key_html
    let component = a:window.component
    if component.hasHTML()
      call popup_close(a:winId, component.getHTML().path)
      return 1
    endif
  endif
  if a:key ==# g:ngswitcher_list_shortcut_key_css
    let component = a:window.component
    if component.hasCSS()
      call popup_close(a:winId, component.getCSS().path)
      return 1
    endif
  endif
  if a:key ==# g:ngswitcher_list_shortcut_key_ts
    let component = a:window.component
    if component.hasTS()
      call popup_close(a:winId, component.getTS().path)
      return 1
    endif
  endif
  if a:key ==# g:ngswitcher_list_shortcut_key_spec
    let component = a:window.component
    if component.hasSpec()
      call popup_close(a:winId, component.getSpec().path)
      return 1
    endif
  endif
  return 0
endfunction

function! s:onPopupClose(winId, path) abort
  if filereadable(a:path)
    echo a:path
    execute 'e  ' . a:path
  endif
endfunction

function! s:updateHighlight(window, winId) abort
  let l:bufnr = winbufnr(a:winId)
  if l:bufnr == -1
    return
  endif
  call prop_remove({ 'type': 'currentLine', 'bufnr': bufnr })
  call prop_add(a:window.currentLine, a:window.hlColOffset, {
        \ 'type': 'currentLine', 
        \ 'bufnr': bufnr,
        \ 'length': len(a:window.getTextOnCursor())
        \ })
  call win_execute(a:winId, 'redraw')
endfunction

let s:Window = {
      \ 'currentLine': 1,
      \ 'dirstLine': 1,
      \ 'lastLine': 1,
      \ 'hlColOffset': 1,
      \ 'files': [],
      \ 'textLines': []
      \ }

function! s:Window.moveUp() abort
  if self.currentLine - 1 >= self.firstLine
    let self.currentLine -= 1
  endif
endfunction

function! s:Window.moveDown() abort
  if self.currentLine + 1 <= self.lastLine
    let self.currentLine += 1
  endif
endfunction

function! s:Window.getFileOnCursor() abort
  let index = self.currentLine - 1
  if 0 <= index && index < len(self.files)
    return self.files[index]
  endif
endfunction

function! s:Window.getTextOnCursor() abort
  let index = self.currentLine - 1
  if 0 <= index && index < len(self.textLines)
    return self.textLines[index]
  endif
endfunction

let s:WindowFactory = {}

function! s:WindowFactory.create(component) abort
  let htmlKey = substitute(g:ngswitcher_list_shortcut_key_html, '\', '', 'g')
  let tsKey = substitute(g:ngswitcher_list_shortcut_key_ts, '\', '', 'g')
  let cssKey = substitute(g:ngswitcher_list_shortcut_key_css, '\', '', 'g')
  let specKey = substitute(g:ngswitcher_list_shortcut_key_spec, '\', '', 'g')
  let maxKeyLen = max([len(htmlKey), len(tsKey), len(cssKey), len(specKey)])

  let currentFile = a:component.getCurrentFile()
  let files = [currentFile]
  let textLines = ['[x] ' . repeat(' ', maxKeyLen - 1) . currentFile.path]
  if a:component.hasHTML() && !currentFile.isHTML()
    call add(files, a:component.getHTML())
    call add(textLines, '[' . htmlKey . '] ' . repeat(' ', maxKeyLen - len(htmlKey)) . a:component.getHTML().path)
  endif
  if a:component.hasCSS() && !currentFile.isCSS()
    call add(files, a:component.getCSS())
    call add(textLines, '[' . cssKey . '] ' . repeat(' ', maxKeyLen - len(cssKey)) . a:component.getCSS().path)
  endif
  if a:component.hasTS() && !currentFile.isTS()
    call add(files, a:component.getTS())
    call add(textLines, '[' . tsKey . '] ' . repeat(' ', maxKeyLen - len(tsKey)) . a:component.getTS().path)
  endif
  if a:component.hasSpec() && !currentFile.isSpec()
    call add(files, a:component.getSpec())
    call add(textLines, '[' . specKey . '] ' . repeat(' ', maxKeyLen - len(specKey)) . a:component.getSpec().path)
  endif

  let window = deepcopy(s:Window)
  let window.firstLine = len(files) < 2 ? len(files) : 2
  let window.currentLine = window.firstLine
  let window.lastLine = len(files)
  let window.hlColOffset = maxKeyLen + 4
  let window.files = files
  let window.textLines = textLines
  let window.component = a:component
  return window
endfunction

function! ngswitcher#window#getWindowFactory() abort
  return s:WindowFactory
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
