#!/usr/bin/env bash



csfile="$1"/cscope.file

if [[ -r "$1"  ]]; then
    cd $1
    echo -e "\n--- generate tags ---\n"
    
    if [[ -r "_prj" ]]; then
        ctags -R --fields=+aimS --languages=php -f _prj/tags 
    else
        ctags -R --fields=+aimS --languages=php 
    fi
    
    find . -name '*.php'  > $csfile
    find . -name '*.html' >> $csfile
    find . -name '*.sh'   >> $csfile
    find . -name '*.conf' >> $csfile
    find . -name '*.js'   >> $csfile
    find . -name '*.sql'  >> $csfile
    find . -name '*.css'  >> $csfile
    find . -name '*.tpl'  >> $csfile
    # find . -name '*.c'    >> $csfile
    # find . -name '*.h'    >> $csfile
    # find . -name '*.cpp'  >> $csfile

    # 捕获 pylon 框架源码
    if [[ -r "$1/_rg/svc.yaml" ]]; then
        pylon_src=`sed '/PYLON/!d' $1/_rg/svc.yaml | awk '{print $NF}' | tr -d '"'`
        if [[ -r $pylon_src ]]; then
            echo -e "--- generate pylon_tags ---\n"
            cd $pylon_src
            ctags -R --tag-relative  --fields=+aimS --languages=php -f $1/_prj/pylon_tags
            cd $1
            find $pylon_src/ -name '*.php'  >> $csfile
        fi
    fi

    # 调用 cscope.files 文件生成 cscope.out
    echo -e "--- gererate cscope.out ---"
    cscope -b -i $csfile
    rm -rf $csfile
    if [[ -r "_prj" ]]; then
        mv cscope.out _prj/cscope.out
    fi    
fi

