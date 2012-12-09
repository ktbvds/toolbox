#!/bin/bash
if ! grep '^MEMCACHED$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${MEMCACHED_SRC}
    get_file
    unpack
    
    CONFIG="./configure \
    --prefix=${INST_DIR}/${SRC_DIR} \
    --enable-64bit"

    if [ "${INST_MODE}" = 'all' ]; then

        LIBEVENT_SYMLINK=$(readlink -f /usr/local/libevent)
        LIBEVENT_DIR=${LIBEVENT_SYMLINK:-/usr/local/libevent}

        LDFLAGS="-L${LIBEVENT_DIR}/lib -Wl,-rpath,${LIBEVENT_DIR}/lib"
        CPPFLAGS="-I${LIBEVENT_DIR}/include"

        CONFIG="${CONFIG} --with-libevent=${LIBEVENT_DIR}"
    fi

    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/memcached'
    compile

    rm -rf "${INST_DIR}/${SRC_DIR}/share"

## record installed tag   
    echo 'MEMCACHED' >> ${INST_LOG}
fi
