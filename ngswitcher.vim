let s:suite = themis#suite('ngswitcher')
let s:assert = themis#helper('assert')

function! s:suite.hello_test()
  call s:assert.equals(ngswitcher#hello(), "Hello")
endfunction
