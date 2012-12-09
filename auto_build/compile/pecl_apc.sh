#!/bin/bash
if ! grep '^PECL_APC$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${PECL_APC_SRC}

## find php installed dir
    PHP_SYMLINK=$(readlink -f /usr/local/php)
    PHP_DIR=${PHP_SYMLINK:-/usr/local/php}
    
    PRE_CONFIG="${PHP_DIR}/bin/phpize"
    CONFIG="./configure --enable-apc --with-php-config=${PHP_DIR}/bin/php-config"
    MAKE='make'
    INSTALL='install -s -m 0755 modules/apc.so ${PHP_DIR}/ext'

    get_file
    unpack 
    compile

## record installed tag    
    echo 'PECL_APC' >> ${INST_LOG}
fi
