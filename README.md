# ngswitcher.vim ![CI](https://github.com/softoika/ngswitcher.vim/workflows/CI/badge.svg)
Quickly switch between Angular files for Vim. Inspired by [angular2-switcher](https://github.com/infinity1207/angular2-switcher), an extension of VSCode.

## Provided commands
|Command|Description|
|---|---|
|`:NgSwitchTS` |  Open a TypeScript(.ts) file in the same component. If on ts file, open a previous file.
|`:NgSwitchHTML` | Open a HTML(.html) file in the same component. If on html file, open a previous file.
|`:NgSwitchCSS` | Open a stylesheet(.css/.scss/.sass/.stylus) file in the same component. If on stylesheet file, open a previous file.
|`:NgSwitchSpec` | Open a spec (.spec.ts/.test.ts) file in the  same component. If on spec file, open a previous file.

:bulb: `:SNgSwitchTS`, `:VNgSwitchTS`, etc. splits window horizontally or vertically.

## Key mapping examples
```vim
nnoremap <Leader>u :<C-u>NgSwitchTS<CR>
nnoremap <Leader>i :<C-u>NgSwitchCSS<CR>
nnoremap <Leader>o :<C-u>NgSwitchHTML<CR>
nnoremap <Leader>p :<C-u>NgSwitchSpec<CR>

" with horizontal split
nnoremap <leader>su :<C-u>SNgSwitchTS<CR>
nnoremap <leader>si :<C-u>SNgSwitchCSS<CR>
nnoremap <leader>so :<C-u>SNgSwitchHTML<CR>
nnoremap <leader>sp :<C-u>SNgSwitchSpec<CR>

" with vertical split
nnoremap <leader>vu :<C-u>VNgSwitchTS<CR>
nnoremap <leader>vi :<C-u>VNgSwitchCSS<CR>
nnoremap <leader>vo :<C-u>VNgSwitchHTML<CR>
nnoremap <leader>vp :<C-u>VNgSwitchSpec<CR>
```

## Supported environment
- Latest Vim(8.0 or later) and neovim
- Multi-platform
  - Windows
  - macOS
  - Linux

## Testing in local
```bash
# In this repository
$ git clone https://github.com/thinca/vim-themis
./vim-themis/bin/themis test
```
