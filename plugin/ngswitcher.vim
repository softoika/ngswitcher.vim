if exists('g:loaded_ngswitcher')
  finish
endif
let g:loaded_ngswitcher = 1

if !exists(':NgSwitchTS')
  command NgSwitchTS :call ngswitcher#switch(function('ngswitcher#toTS'), 'edit')
endif

if !exists(':SNgSwitchTS')
  command SNgSwitchTS :call ngswitcher#switch(function('ngswitcher#toTS'), 'split')
endif

if !exists(':VNgSwitchTS')
  command VNgSwitchTS :call ngswitcher#switch(function('ngswitcher#toTS'), 'vsplit')
endif

if !exists(':NgSwitchHTML')
  command NgSwitchHTML :call ngswitcher#switch(function('ngswitcher#toHTML'), 'edit')
endif

if !exists(':SNgSwitchHTML')
  command SNgSwitchHTML :call ngswitcher#switch(function('ngswitcher#toHTML'), 'split')
endif

if !exists(':VNgSwitchHTML')
  command VNgSwitchHTML :call ngswitcher#switch(function('ngswitcher#toHTML'), 'vsplit')
endif

if !exists(':NgSwitchCSS')
  command NgSwitchCSS :call ngswitcher#switch(function('ngswitcher#toCSS'), 'edit')
endif

if !exists(':SNgSwitchCSS')
  command SNgSwitchCSS :call ngswitcher#switch(function('ngswitcher#toCSS'), 'split')
endif

if !exists(':VNgSwitchCSS')
  command VNgSwitchCSS :call ngswitcher#switch(function('ngswitcher#toCSS'), 'vsplit')
endif

if !exists(':NgSwitchSpec')
  command NgSwitchSpec :call ngswitcher#switch(function('ngswitcher#toSpec'), 'edit')
endif

if !exists(':SNgSwitchSpec')
  command SNgSwitchSpec :call ngswitcher#switch(function('ngswitcher#toSpec'), 'split')
endif

if !exists(':VNgSwitchSpec')
  command VNgSwitchSpec :call ngswitcher#switch(function('ngswitcher#toSpec'), 'vsplit')
endif

if !exists(':NgShowList')
  command NgShowList :call ngswitcher#showList()
endif
