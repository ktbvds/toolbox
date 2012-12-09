#!/bin/bash
## Caution : if you update your system and kernel is update to new version , you need to recompile keepalived when you use ipvsadm (lvs).
if ! grep '^KEEPALIVED$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${KEEPALIVED_SRC}
    get_file
    unpack

    CONFIG="./configure --prefix=${INST_DIR}/${SRC_DIR}"
    ## generally, you don't need add '--with-kernel-dir', it will auto find.
    #CONFIG="./configure --prefix=${INST_DIR}/${SRC_DIR} --with-kernel-dir=/usr/src/kernels/$(uname -r)"

    if [ "${INST_MODE}" = 'all' ]; then

        OPENSSL_SYMLINK=$(readlink -f /usr/local/openssl)
        OPENSSL_DIR=${OPENSSL_SYMLINK:-/usr/local/openssl}

        ZLIB_SYMLINK=$(readlink -f /usr/local/zlib)
        ZLIB_DIR=${ZLIB_SYMLINK:-/usr/local/zlib}

        LDFLAGS="-L${ZLIB_DIR}/lib -L${OPENSSL_DIR}/lib -Wl,-rpath,${ZLIB_DIR}/lib -Wl,-rpath,${OPENSSL_DIR}/lib"
        CPPFLAGS="-I${ZLIB_DIR}/include -I${OPENSSL_DIR}/include"
        
    fi

## for compile
    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/keepalived'
    compile

    rm -rf ${INST_DIR}/${SRC_DIR}/share
    rm -rf ${INST_DIR}/${SRC_DIR}/etc/*
    
## for install config files
    if [ "${INST_CONF}" -eq 1 ];then
        succ_msg "Begin to install ${SRC_DIR} config files"
        ## conf
        install -m 0644 ${TOP_DIR}/conf/keepalived/keepalived.conf ${INST_DIR}/${SRC_DIR}/etc/keepalived.conf
        ## init scripts
        install -m 0755 ${TOP_DIR}/conf/keepalived/keepalived.init /etc/init.d/keepalived
        chkconfig --add keepalived
        ## start
        service keepalived start
    fi

## record installed tag
    echo 'KEEPALIVED' >> ${INST_LOG}
fi
