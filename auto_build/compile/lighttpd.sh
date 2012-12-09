#!/bin/bash
if ! grep '^LIGHTTPD$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${LIGHTTPD_SRC}
    get_file
    unpack

    CONFIG="./configure \
    --prefix=${INST_DIR}/${SRC_DIR} \
    --enable-lfs \
    --with-openssl \
    --with-pcre \
    --with-zlib"

    if [ "${INST_MODE}" = 'all' ]; then

        ## get dependent library dir
        OPENSSL_SYMLINK=$(readlink -f /usr/local/openssl)
        OPENSSL_DIR=${OPENSSL_SYMLINK:-/usr/local/openssl}

        ZLIB_SYMLINK=$(readlink -f /usr/local/zlib)
        ZLIB_DIR=${ZLIB_SYMLINK:-/usr/local/zlib}

        PCRE_SYMLINK=$(readlink -f /usr/local/pcre)
        PCRE_DIR=${PCRE_SYMLINK:-/usr/local/pcre}

        ## use ldflags and cppflags for compile and link
        LDFLAGS="-L${ZLIB_DIR}/lib -L${OPENSSL_DIR}/lib -L${PCRE_DIR}/lib -Wl,-rpath,${ZLIB_DIR}/lib -Wl,-rpath,${OPENSSL_DIR}/lib -Wl,-rpath,${PCRE_DIR}/lib"
        CPPFLAGS="-I${ZLIB_DIR}/include -I${OPENSSL_DIR}/include -I${PCRE_DIR}/include"

        CONFIG="./configure \
                --prefix=${INST_DIR}/${SRC_DIR} \
                --enable-lfs \
                --with-openssl=${OPENSSL_DIR} \
                --with-pcre \
                --with-zlib"
    fi

## for compile
    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/lighttpd'
    compile

## for install config files
    if [ "${INST_CONF}" -eq 1 ];then
        succ_msg "Begin to install ${SRC_DIR} config files"
        ## user add
        #id www >/dev/null 2>&1 || useradd www -u 1001 -M -s /sbin/nologin -d /www/wwwroot
        ## conf
        
        ## log

        ## ca scripts
        #install -m 0755 ${TOP_DIR}/conf/nginx/ca.sh /usr/local/sbin
        ## create certs
        #/usr/local/sbin/ca.sh
        ## init scripts
        #install -m 0755 ${TOP_DIR}/conf/lighttpd/lighttpd.init /etc/init.d/lighttpd
        #chkconfig --add lighttpd
    fi

## record installed tag
    echo 'LIGHTTPD' >> ${INST_LOG}
fi
