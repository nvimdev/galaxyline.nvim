if exists('g:loaded_galaxyline') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

if !has('nvim')
    echohl Error
    echom "Sorry this plugin only works with versions of neovim that support lua"
    echohl clear
    finish
endif

let g:loaded_galaxyline = 1

augroup galaxyline
  autocmd!
  autocmd FileType,BufWinEnter,BufReadPost,BufWritePost * lua require('galaxyline').load_galaxyline()
  autocmd BufEnter,WinEnter,BufEnter,FileChangedShellPost  * lua require('galaxyline').load_galaxyline()
  autocmd VimResized * lua require('galaxyline').load_galaxyline()
  autocmd WinLeave * lua require('galaxyline').inactive_galaxyline()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
