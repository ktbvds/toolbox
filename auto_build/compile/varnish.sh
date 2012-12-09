#!/bin/bash
if ! grep '^VARNISH$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${VARNISH_SRC}
    get_file
    unpack

## for compile
    CONFIG=""

    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/varnish'
    compile

## for install config files
    if [ "${INST_CONF}" -eq 1 ];then
        succ_msg "Begin to install ${SRC_DIR} config files"
        # need add
    fi

## record installed tag
    echo 'VARNISH' >> ${INST_LOG}
fi
