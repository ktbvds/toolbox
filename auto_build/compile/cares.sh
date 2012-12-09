#!/bin/bash
if ! grep '^CARES$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${CARES_SRC}
    get_file
    unpack

## compile
    CONFIG="./configure \
            --prefix=${INST_DIR}/${SRC_DIR} \
            --enable-optimize \
            --enable-nonblocking \
            --disable-static \
            --disable-debug \
            --disable-curldebug"

    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/c-ares'
    compile

## clean files    
    rm -rf "${INST_DIR}/${SRC_DIR}/share"

## record installed tag
    echo 'CARES' >> ${INST_LOG}
fi
