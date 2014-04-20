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

"   au BufReadPost *
"        \ if line("'\"") > 1 && line("'\"") <= line("$") |
"       \   exe "normal! g`\"" |
"       \ endif
" 
"  function! ResCur()
"      if line("'\"") <= line("$")
"          normal! g`"
"          return 1
"      endif
"  endfunction
" 
"  augroup resCur
"      autocmd!
"      autocmd BufWinEnter * call ResCur()
"  augroup END
" 

"Go to last file(s) if invoked without arguments.
autocmd VimLeave * NERDTreeClose
autocmd VimLeave * TagbarClose
autocmd BufWinLeave * call VjBufClose()
autocmd VimLeave * nested call VjClose()

" 实验性特性
" 若离开前窗口不是NERDTree 且只有两个窗口 且 NerdTree是打开状态，则保存session
func! VjBufClose()
    if ! exists("b:NERDTreeType") && winnr("$") == 2 
        if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
            call SaveSession(FindProjectName())
        endif 
    endif 
endf

if ! isdirectory('~/.vim/sessions/')
   silent exec '!mkdir -p ~/.vim/sessions'
endif

func! FindProjectName()
    let s:name = getcwd()
    if !isdirectory(".git")
        let s:name = substitute(finddir(".git", ".;"), "/.git", "", "")
    endif 
    if s:name != ""
        let s:name = matchstr(s:name, ".*", strridx(s:name, "/") + 1)
    endif 
    return s:name
endf

func! RestoreSession(name)
    if a:name != ""
        if filereadable($HOME . "/.vim/sessions/" . a:name)
            execute 'source ' . $HOME . "/.vim/sessions/" . a:name
        end
    end
endf

func! SaveSession(name)
    if a:name != ""
        execute 'mksession! ' . $HOME.'/.vim/sessions/'.a:name
    end
endf

 if ! exists("g:vj_open_last_file_mode")
     set ssop+=resize
     set ssop+=winpos
     set ssop-=options
     set ssop-=curdir
     set ssop-=tabpages
     set ssop-=blank
     set ssop-=buffers 
    let g:vj_open_last_file_mode=1
 endif

if ! exists("g:vj_source_from_code_mode")
    let g:vj_source_from_code_mode=0
endif

func! VjClose()
    call SaveSession(FindProjectName()) 
endf

func! VjOpen()
    let a:session_name = FindProjectName()
    if g:vj_open_last_file_mode != 0 && a:session_name != ''
        call RestoreSession(a:session_name)
    endif
    if g:vj_source_from_code_mode == 0
        NERDTreeTabsToggle
    else
        NERDTreeFind
    endif
endf

function! PhpBeautify()
    exec '% ! php_beautifier --filters "Pear() NewLines(before=public:class:private) ArrayNested() IndentStyles(style=k&r)"'
endfunction
