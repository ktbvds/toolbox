#!/bin/bash
if ! grep '^PECL_REDIS$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${PECL_REDIS_SRC}
    get_file
    unpack

## find php installed dir
    PHP_SYMLINK=$(readlink -f /usr/local/php)
    PHP_DIR=${PHP_SYMLINK:-/usr/local/php}
    
    PRE_CONFIG="${PHP_DIR}/bin/phpize"
    CONFIG="./configure --enable-redis --with-php-config=${PHP_DIR}/bin/php-config"
    MAKE='make'
    INSTALL='install -s -m 0755 modules/redis.so ${PHP_DIR}/ext'
    
    compile

## record installed tag    
    echo 'PECL_REDIS' >> ${INST_LOG}

fi
