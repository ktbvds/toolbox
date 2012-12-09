#!/bin/bash
if ! grep '^TT$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${TT_SRC}
    get_file
    unpack

## get dependent library dir
    TC_SYMLINK=$(readlink -f /usr/local/tokyocabinet)
    TC_DIR=${TC_SYMLINK:-/usr/local/tokyocabinet}

## use ldflags and cppflags for compile and link 
    LDFLAGS="-L${TC_DIR}/lib -Wl,-rpath,${TC_DIR}/lib"
    CPPFLAGS="-I${TC_DIR}/include"
    
    CONFIG="./configure \
    --prefix=${INST_DIR}/${SRC_DIR} \
    --disable-debug \
    --disable-static \
    --with-tc=${TC_DIR}"

    if [ "${INST_MODE}" = 'all' ]; then

        ZLIB_SYMLINK=$(readlink -f /usr/local/zlib)
        ZLIB_DIR=${ZLIB_SYMLINK:-/usr/local/zlib}

        LDFLAGS="$LDFLAGS -L${ZLIB_DIR}/lib -Wl,-rpath,${ZLIB_DIR}/lib"
        CPPFLAGS="$CPPFLAGS -I${ZLIB_DIR}/include"

        CONFIG="${CONFIG} --with-zlib=${ZLIB_DIR}"
    fi

    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/tokyotyrant'
    compile

## record installed tag 
    echo 'TT' >> ${INST_LOG}
fi
