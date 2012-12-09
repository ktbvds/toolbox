#!/bin/bash
if ! grep '^TRAFFICESERVER$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${TRAFFICESERVER_SRC}
    get_file
    unpack

    CONFIG="./configure \
    --prefix=${INST_DIR}/${SRC_DIR} \
    --enable-standalone-iocore \
    --enable-wccp"

## for compile
    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/trafficserver'
    compile

## for install config files
    if [ "${INST_CONF}" -eq 1 ];then
        succ_msg "Begin to install ${SRC_DIR} config files"
        # need add
    fi

## record installed tag
    echo 'TRAFFICESERVER' >> ${INST_LOG}
fi
