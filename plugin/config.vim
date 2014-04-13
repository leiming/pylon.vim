if exists('g:pylon_ide_config')
  finish
endif 

let g:pylon_ide_config = 1

func! FileTypeToggle()
  let a:ft=&filetype
  if a:ft == 'php'
    set ft=html
    echo 'set filetype=html'
  elseif a:ft == 'html'
    set ft=php
    echo 'set filetype=php'
  endif
endf

au BufReadPost *
     \ if line("'\"") > 1 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif


"Go to last file(s) if invoked without arguments.
autocmd VimLeave * nested if (!isdirectory($HOME . "/.vim")) |
    \ call mkdir($HOME . "/.vim") |
    \ endif |
    \ exec ":NERDTreeTabsClose" |
    \ exec ":TagbarClose" |
    \ execute "mksession! " . $HOME . "/.vim/Session.vim" 

if ! exists("g:vj_open_last_file_mode")
    let g:vj_open_last_file_mode=1
endif

if ! exists("g:vj_source_from_code_mode")
    let g:vj_source_from_code_mode=0
endif

func! VjOpen()
    if g:vj_open_last_file_mode != 0 && filereadable($HOME . "/.vim/Session.vim")
        execute "source " . $HOME . "/.vim/Session.vim"
    endif
    if g:vj_source_from_code_mode == 0
        NERDTreeTabsToggle
    else
        NERDTreeFind
    endif
endf
