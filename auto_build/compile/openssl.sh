#!/bin/bash
if ! grep '^OPENSSL$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${OPENSSL_SRC}
    get_file
    unpack
    
    ZLIB_SYMLINK=$(readlink -f /usr/local/zlib)
    ZLIB_DIR=${ZLIB_SYMLINK:-/usr/local/zlib}

    PRE_CONFIG="./config \
    --prefix=${INST_DIR}/${SRC_DIR} \
    --openssldir=${INST_DIR}/${SRC_DIR} \
    shared zlib threads --with-krb5-flavor=MIT \
    enable-md2 enable-camellia enable-seed enable-tlsext enable-rfc3779 \
    no-idea no-mdc2 no-rc5 no-ec no-ecdh no-ecdsa \
    -I${ZLIB_DIR}/include -L${ZLIB_DIR}/lib -Wl,-rpath,${ZLIB_DIR}/lib"
    
    CONFIG='make depend'
    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/openssl'
    compile

## clean files 
    rm -rf "${INST_DIR}/${SRC_DIR}/man"

## record installed tag
    echo 'OPENSSL' >> ${INST_LOG}
fi
