#!/bin/bash
if ! grep '^PHP$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${PHP_SRC}
    get_file
    unpack

## find mysql installed dir, but it is not used, use php mysqlnd lib instead.
    MYSQL_SYMLINK=$(readlink -f /usr/local/mysql)
    MYSQL_DIR=${MYSQL_SYMLINK:-/usr/local/mysql}

    CONFIG="./configure \
            --prefix=${INST_DIR}/${SRC_DIR} \
            --with-config-file-path=${INST_DIR}/${SRC_DIR}/etc \
            --with-curl \
            --with-libxml-dir \
            --with-mysql \
            --with-mysqli \
            --with-openssl \
            --with-pdo-mysql \
            --with-zlib \
            --without-pdo-sqlite \
            --without-pear \
            --without-sqlite3 \
            --disable-cgi \
            --disable-ipv6 \
            --disable-phar \
            --enable-fpm \
            --enable-mbstring"

    if [ "${INST_MODE}" = 'all' ]; then

        CURL_SYMLINK=$(readlink -f /usr/local/curl)
        CURL_DIR=${CURL_SYMLINK:-/usr/local/curl}

        LIBXML2_SYMLINK=$(readlink -f /usr/local/libxml2)
        LIBXML2_DIR=${LIBXML2_SYMLINK:-/usr/local/libxml2}

        ZLIB_SYMLINK=$(readlink -f /usr/local/zlib)
        ZLIB_DIR=${ZLIB_SYMLINK:-/usr/local/zlib}

        OPENSSL_SYMLINK=$(readlink -f /usr/local/openssl)
        OPENSSL_DIR=${OPENSSL_SYMLINK:-/usr/local/openssl}

        LDFLAGS="-L${ZLIB_DIR}/lib -L${OPENSSL_DIR}/lib -L${CURL_DIR}/lib -L${LIBXML2_DIR} -Wl,-rpath,${ZLIB_DIR}/lib -Wl,-rpath,${OPENSSL_DIR}/lib -Wl,-rpath,${CURL_DIR}/lib -Wl,-rpath,${LIBXML2_DIR}/lib"
        CPPFLAGS="-I${ZLIB_DIR}/include -I${OPENSSL_DIR}/include -I${CURL_DIR}/include -I${LIBXML2_DIR}"

        CONFIG="./configure \
                --prefix=${INST_DIR}/${SRC_DIR} \
                --with-config-file-path=${INST_DIR}/${SRC_DIR}/etc \
                --with-curl=${CURL_DIR} \
                --with-libxml-dir=${LIBXML2_DIR} \
                --with-mysql \
                --with-mysqli \
                --with-openssl=${OPENSSL_DIR} \
                --with-pdo-mysql \
                --with-zlib=${ZLIB_DIR} \
                --without-pdo-sqlite \
                --without-pear \
                --without-sqlite3 \
                --disable-cgi \
                --disable-ipv6 \
                --disable-phar \
                --enable-fpm \
                --enable-mbstring"

    fi

## for compile
    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/php'
    compile
    
    mkdir ${INST_DIR}/${SRC_DIR}/ext
    rm -rf ${INST_DIR}/${SRC_DIR}/{man,var,php}

## for install config files
    if [ "${INST_CONF}" -eq 1 ];then
        succ_msg "Begin to install ${SRC_DIR} config files"
        ## user add
        id www >/dev/null 2>&1 || useradd www -u 1001 -M -s /sbin/nologin -d /www/wwwroot
        ## www dir
        [ ! -d "/www/wwwroot" ] && mkdir -m 0755 -p /www/wwwroot
        ## conf
        install -m 0644 ${TOP_DIR}/conf/php/php.ini ${INST_DIR}/${SRC_DIR}/etc/php.ini
        install -m 0644 ${TOP_DIR}/conf/php/php-fpm.conf ${INST_DIR}/${SRC_DIR}/etc/php-fpm.conf
        ## log
        mkdir -m 0755 /var/log/php
        chown www:www -R /var/log/php
        install -m 0644 ${TOP_DIR}/conf/php/php-fpm.logrotate /etc/logrotate.d/php-fpm
        ## init scripts
        install -m 0755 ${TOP_DIR}/conf/php/php-fpm.init /etc/init.d/php-fpm
        chkconfig --add php-fpm
        ## start
        service php-fpm start
    fi

## record installed tag
    echo 'PHP' >> ${INST_LOG}
fi
