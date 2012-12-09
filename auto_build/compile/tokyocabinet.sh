#!/bin/bash
if ! grep '^TC$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${TC_SRC}
    get_file
    unpack

    CONFIG="./configure \
    --prefix=${INST_DIR}/${SRC_DIR} \
    --disable-debug \
    --disable-static"

    if [ "${INST_MODE}" = 'all' ]; then
        ZLIB_SYMLINK=$(readlink -f /usr/local/zlib)
        ZLIB_DIR=${ZLIB_SYMLINK:-/usr/local/zlib}
        
        LDFLAGS="-L${ZLIB_DIR}/lib -Wl,-rpath,${ZLIB_DIR}/lib"
        CPPFLAGS="-I${ZLIB_DIR}/include"

        CONFIG="${CONFIG} --with-zlib=${ZLIB_DIR}"
    fi

    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/tokyocabinet'
    compile

## record installed tag   
    echo 'TC' >> ${INST_LOG}
fi
