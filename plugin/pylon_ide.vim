if exists("pylon_ide_loaded")
    finish
endif
let pylon_ide_loaded = 1

function Pylon_build_index()
    silent execute "! echo -e ---- Building cscope ----\n"
    silent execute  '! ' . g:pylon_prjroot. '/_prj/srcindex.sh ' 
    silent execute  "cs kill -1 "
    silent execute  "cs add " . g:pylon_prjroot. '/_prj/cscope.out  '
    if executable('phpctags')
        " silent execute "! echo -e ---- Building phpctags, please wait ... ----"
        " silent execute "! phpctags -R -f tmp/tags --languages=php --fields=+iaS --extra=+q ."
        " silent execute "! echo -e ---- Building ctags ----\n"
        " silent execute "! ctags -R --append=yes -f tmp/tags --languages=+all,-php --fields=+iaS --extra=+q ."
    elseif
        " silent execute "! echo -e ---- Building ctags ----\n"
        "silent execute "! ctags -R -f tmp/tags --languages=+all --fields=+iaS --extra=+q ."
    endif
    " silent execute "set tags=tmp/tags,".&tags
    execute "! echo -e ---- Finished ----"
endfunction

function Pylon_prj_cmd(cmd)
    execute  '! ' . g:pylon_prjroot. '/_prj/' . a:cmd 
endfunction

function Pylon_debug_watch(varname,type)
    let n= line('.')  
    let pos = indent('.')
    let watchstr = repeat(" ",pos) .   printf("Debug::watch(__FILE__,__LINE__,%s,'%s');",a:varname,a:varname)
    if a:type == "up" 
        let    n = n-1
    endif
    call append(n,watchstr)
endfunction

function Pylon_dbc_add_nl2(varname,type)
    let pos = indent('.')
    let watchstr = repeat(" ",pos+4) . printf("DBC::%s(%s,'%s');",a:type,a:varname,a:varname)
    let n= line('.')  
    call append(n+1,watchstr)
endfunction

function Pylon_dbc_add(varname,type)
    let pos = indent('.')
    let watchstr = repeat(" ",pos) . printf("DBC::%s(%s,'%s');",a:type,a:varname,a:varname)
    let n= line('.')  
    call append(n,watchstr)
endfunction


let g:pylon_prj_init="init.sh"
let g:pylon_prj_ci  = "ci.sh"


function Pylon_ide_init(prjroot )
    let g:pylon_prjroot = a:prjroot 
    noremap <F9> <Esc>: call Pylon_build_index() <CR>
    noremap <F8> <Esc>: call Pylon_prj_cmd(g:pylon_prj_init) <CR>
    noremap <F7> <Esc>: call Pylon_prj_cmd("build_index.sh") <CR>
    map \zci <Esc>:call Pylon_prj_cmd(g:pylon_prj_ci) <CR>

    noremap \dw <Esc>:call Pylon_debug_watch(expand("<cword>"),"down")<CR> 
    noremap \dW <Esc>:call Pylon_debug_watch(expand("<cWORD>"),"down")<CR> 
    noremap \du <Esc>:call Pylon_debug_watch(expand("<cword>"),"up")<CR> 
    noremap \dU <Esc>:call Pylon_debug_watch(expand("<cWORD>"),"up")<CR> 

    noremap \re <Esc>:call Pylon_dbc_add_nl2(expand("<cword>"),"requireNotNull")<CR> 
    noremap \rn <Esc>:call Pylon_dbc_add_nl2(expand("<cword>"),"requireNotNull")<CR> 
    noremap \rt <Esc>:call Pylon_dbc_add_nl2(expand("<cword>"),"requireTrue")<CR> 
    noremap \rue <Esc>:call Pylon_dbc_add(expand("<cword>"),"unExpect")<CR> 
    noremap \rui <Esc>:call Pylon_dbc_add("__FUNCTION__"),"unImplement")<CR> 

    ia s1   echo "---------------step 1 ---------------<br>\n";
    ia s2   echo "---------------step 2 ---------------<br>\n";
    ia s3   echo "---------------step 3 ---------------<br>\n";
    ia s4   echo "---------------step 4 ---------------<br>\n";
    ia s5   echo "---------------step 5 ---------------<br>\n";
    ia s6   echo "---------------step 6 ---------------<br>\n";
    ia s7   echo "---------------step 7 ---------------<br>\n";
    ia s8   echo "---------------step 8 ---------------<br>\n";
    ia s9   echo "---------------step 9 ---------------<br>\n";

    :command! -nargs=1 Ap :cs find  s do_<args>
    :command! -nargs=1 Af :cs find  t -><args>

endfunction

function Probe_ide_init(prjroot )
    :call Pylon_ide_init(a:prjroot)
endfunction
"noremap <unique> <script> <Plug><SID>Add

" 获得项目的根目录
let s:prjroot=fnamemodify('',':p')

function! MapUnitTest()
    if filereadable(s:prjroot.'test/unittest.sh')
        exec '!sudo sh '. s:prjroot .'test/unittest.sh'
    endif
endfunction

"若项目根目录下_prj/in.vim文件存在，则定义F2映射和加载Pylon插件
if filereadable(s:prjroot.'_prj/in.vim')
    noremap <F2> <Esc> :call MapUnitTest() <CR>
    call Probe_ide_init(strpart(s:prjroot, 0, strlen(s:prjroot)-1 ))
endif

