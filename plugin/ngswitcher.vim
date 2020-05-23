if exists('g:loaded_ngswitcher')
  finish
endif
let g:loaded_ngswitcher = 1

if !exists(':NgSwitchTS')
  command NgSwitchTS :call ngswitcher#switch(function('ngswitcher#toTS'))
endif

if !exists(':NgSwitchHTML')
  command NgSwitchHTML :call ngswitcher#switch(function('ngswitcher#toHTML'))
endif

if !exists(':NgSwitchCSS')
  command NgSwitchCSS :call ngswitcher#switch(function('ngswitcher#toCSS'))
endif

if !exists(':NgSwitchSpec')
  command NgSwitchSpec :call ngswitcher#switch(function('ngswitcher#toSpec'))
endif

if !exists(':NgShowList')
  command NgShowList :call ngswitcher#showList()
endif
