scriptencoding utf-8

if exists('g:loaded_gitui_vim') | finish | endif

let s:save_cpo = &cpoptions
set cpoptions&vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !exists('g:gitui_floating_window_winblend')
    let g:gitui_floating_window_winblend = 0
endif

if !exists('g:gitui_floating_window_scaling_factor')
  let g:gitui_floating_window_scaling_factor = 0.9
endif

if !exists('g:gitui_use_neovim_remote')
  let g:gitui_use_neovim_remote = executable('nvr') ? 1 : 0
endif

if !exists('g:gitui_floating_window_corner_chars')
  let g:gitui_floating_window_corner_chars = ['╭', '╮', '╰', '╯']
endif

command! GitUi lua require'gitui'.gitui()

command! GitUiFilter lua require'gitui'.gituifilter()

command! GitUiFilterCurrentFile lua require'gitui'.gituifiltercurrentfile()

command! GitUiConfig lua require'gitui'.gituiconfig()

""""""""""""""""""""""""""""""""""""""""""""""""""""""

let &cpoptions = s:save_cpo
unlet s:save_cpo

let g:loaded_gitui_vim = 1
