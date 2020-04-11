let s:Logger = { 'logs': [] }

function! s:Logger.collect(log) abort
  call add(self.logs, a:log)
endfunction

function! s:Logger.emit(emitterFunc) abort
  call a:emitterFunc("\n" . join(self.logs, "\n") . "\n")
endfunction

function! s:Logger.clear() abort
  let self.logs = []
endfunction

function! ngswitcher#debug_utils#getLogger() abort
  return s:Logger
endfunction
