#!/bin/bash
## Caution: the scripts below just for jpeg-8d, do not use with jpeg-6b or other versions.
if ! grep '^LIBJPEG$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${LIBJPEG_SRC}
    SRC_DIR='jpeg-8d'
    get_file
    unpack

## get dependent library dir
    ZLIB_SYMLINK=$(readlink -f /usr/local/zlib)
    ZLIB_DIR=${ZLIB_SYMLINK:-/usr/local/zlib}

## use ldflags and cppflags for compile and link
    LDFLAGS="-L${ZLIB_DIR}/lib -Wl,-rpath,${ZLIB_DIR}/lib"
    CPPFLAGS="-I${ZLIB_DIR}/include"

## compile   
    CONFIG="./configure \
    --prefix=${INST_DIR}/${SRC_DIR} \
    --disable-static"

    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/libjpeg'
    compile
    
    rm -rf "${INST_DIR}/${SRC_DIR}/share"

## record installed tag  
    echo 'LIBJPEG' >> ${INST_LOG}
fi
