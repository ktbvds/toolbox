#!/bin/bash
if ! grep '^FREETYPE$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${FREETYPE_SRC}
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
    SYMLINK='/usr/local/freetype'
    compile

## record installed tag  
    echo 'FREETYPE' >> ${INST_LOG}
fi
