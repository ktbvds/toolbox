#!/bin/bash
if ! grep '^LIBPNG$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${LIBPNG_SRC}
    get_file
    unpack

## get dependent library dir
    ZLIB_SYMLINK=$(readlink -f /usr/local/zlib)
    ZLIB_DIR=${ZLIB_SYMLINK:-/usr/local/zlib}

## use ldflags and cppflags for compile and link
    LDFLAGS="-L${ZLIB_DIR}/lib -Wl,-rpath,${ZLIB_DIR}/lib"
    CPPFLAGS="-I${ZLIB_DIR}/include"


    CONFIG="./configure \
    --prefix=${INST_DIR}/${SRC_DIR} \
    --disable-static \
    --with-zlib-prefix=${ZLIB_DIR}"

    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/libpng'
    compile
    
    rm -rf "${INST_DIR}/${SRC_DIR}/share"

## record installed tag
    echo 'LIBPNG' >> ${INST_LOG}
fi
