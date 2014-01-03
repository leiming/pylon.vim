map <F2> <esc>:w<CR>:so %<CR>
imap <F2> <esc>:w<CR>:so %<CR>i

let s:prjroot='$HOME/devspace/pylon_ide/'
let files = system("ls " .  shellescape(expand('%:h')))

function! RunUnitTest()
    if filereadable('_prj/unittest.sh')
        exec '!sudo sh 's:prjroot .'_prj/unittest.sh'
    endif
endfunction

function! Test()
  if  filereadable(s:prjroot.'/in.vim')
      echom 'true'
      let s:ut = s:prjroot.'unittest.sh'
  else
      echom 'false'
  endif
endfunction

map <F5> <esc>:w<CR>:call Test()<CR>
map <F3> <esc>:w<CR>:call RunUnitTest()<CR>
