#!/bin/bash
if ! grep '^PCRE$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${PCRE_SRC}
    get_file
    unpack

    CONFIG="./configure \
    --prefix=${INST_DIR}/${SRC_DIR} \
    --disable-static \
    --enable-jit \
    --enable-utf \
    --enable-unicode-properties"
    
    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/pcre'
    compile

## clean files
    rm -rf "${INST_DIR}/${SRC_DIR}/share"

## record installed tag
    echo 'PCRE' >> ${INST_LOG}
fi
