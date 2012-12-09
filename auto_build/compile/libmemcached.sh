#!/bin/bash
if ! grep '^LIBMEMCACHED$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${LIBMEMCACHED_SRC}
    get_file
    unpack
    
    if [ "${INST_MODE}" = 'all' ]; then

        LIBEVENT_SYMLINK=$(readlink -f /usr/local/libevent)
        LIBEVENT_DIR=${LIBEVENT_SYMLINK:-/usr/local/libevent}

        LDFLAGS="-L${LIBEVENT_DIR}/lib -Wl,-rpath,${LIBEVENT_DIR}/lib"
        CPPFLAGS="-I${LIBEVENT_DIR}/include"
    fi
	
    CONFIG="./configure --prefix=${INST_DIR}/${SRC_DIR} --disable-static"

    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/libmemcached'
    compile
	
    rm -rf "${INST_DIR}/${SRC_DIR}/share"

## record installed tag
    echo 'LIBMEMCACHED' >> ${INST_LOG}
fi
