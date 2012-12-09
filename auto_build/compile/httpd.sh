#!/bin/bash
# httpd-2.4.x
if ! grep '^HTTPD$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle httpd deps (apr and apr-util)
    file_proc ${HTTPD_DEPS_SRC}
    get_file
    unpack
## handle httpd
    file_proc ${HTTPD_SRC}
    get_file
    unpack

## for compile
    PRE_CONFIG='./buildconf'
    CONFIG="./configure \
            --prefix=${INST_DIR}/${SRC_DIR} \
            --disable-static \
            --enable-mpms-shared='prefork worker event' \
            --with-mpm=event \
            --with-included-apr \
            --with-berkeley-db \
            --enable-mods-shared='proxy proxy_connect proxy_fcgi proxy_http ratelimit socache_shmcb info dav dav_fs dav_lock' \
            --enable-mods-static='few remoteip deflate expires ssl rewrite'"

    if [ ${INST_MODE} = 'all' ]; then

        ## get dependent library dir
        ZLIB_SYMLINK=$(readlink -f /usr/local/zlib)
        ZLIB_DIR=${ZLIB_SYMLINK:-/usr/local/zlib}

        OPENSSL_SYMLINK=$(readlink -f /usr/local/openssl)
        OPENSSL_DIR=${OPENSSL_SYMLINK:-/usr/local/openssl}

        LIBXML2_SYMLINK=$(readlink -f /usr/local/libxml2)
        LIBXML2_DIR=${LIBXML2_SYMLINK:-/usr/local/libxml2}

        PCRE_SYMLINK=$(readlink -f /usr/local/pcre)
        PCRE_DIR=${PCRE_SYMLINK:-/usr/local/pcre}

        ## use ldflags and cppflags for compile and link
        LDFLAGS="-L${ZLIB_DIR}/lib -L${OPENSSL_DIR}/lib -L${LIBXML2_DIR}/lib -L${PCRE_DIR} -Wl,-rpath,${ZLIB_DIR}/lib -Wl,-rpath,${OPENSSL_DIR}/lib -Wl,-rpath,${LIBXML2_DIR}/lib -Wl,-rpath,${PCRE_DIR}/lib"
        CPPFLAGS="-I${ZLIB_DIR}/include -I${OPENSSL_DIR}/include -I${LIBXML2_DIR}/include -I${PCRE_DIR}"

        ## for compile
        CONFIG="${CONFIG} \
                --with-z=${ZLIB_DIR} \
                --with-libxml2=${LIBXML2_DIR} \
                --with-ssl=${OPENSSL_DIR} \
                --with-pcre=${PCRE_DIR}"

    fi

## for compile
    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/httpd'
    compile

    rm -rf ${INST_DIR}/${SRC_DIR}/{htdocs,man,manual,logs}

## for install config files
    if [ "${INST_CONF}" -eq 1 ];then
        succ_msg "Begin to install ${SRC_DIR} config files"
        ## user add
        id www >/dev/null 2>&1 || useradd www -u 1001 -M -s /sbin/nologin -d /www/wwwroot
        ## conf
        ## need add 
        ## init scripts
        install -m 0755 ${TOP_DIR}/conf/httpd/httpd.init /etc/init.d/httpd
        chkconfig --add httpd
    fi
    echo 'HTTPD' >> ${INST_LOG}
fi



