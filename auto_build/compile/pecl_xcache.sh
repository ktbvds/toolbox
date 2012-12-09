#!/bin/bash
if ! grep '^PECL_XCACHE$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${PECL_XCACHE_SRC}
    get_file
    unpack

## find php installed dir
    PHP_SYMLINK=$(readlink -f /usr/local/php)
    PHP_DIR=${PHP_SYMLINK:-/usr/local/php}

    PRE_CONFIG="${PHP_DIR}/bin/phpize"
    CONFIG="./configure --enable-xcache --with-php-config=${PHP_DIR}/bin/php-config"
    MAKE='make'
    INSTALL='install -s -m 0755 modules/xcache.so ${PHP_DIR}/ext'
    compile

## record installed tag
    echo 'PECL_XCACHE' >> ${INST_LOG}
fi
