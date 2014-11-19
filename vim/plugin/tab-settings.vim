" Load predefined tab settings

function! s:DefaultTabs()
    set tabstop=8
    set shiftwidth=8
    set noexpandtab
endfunction

command! DefaultTabs call <SID>DefaultTabs()

function! s:FourSpacesTabs()
    set tabstop=4
    set shiftwidth=4
    set expandtab
endfunction

command! FourSpacesTabs call <SID>FourSpacesTabs()
