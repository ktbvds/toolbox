#!/bin/bash
if ! grep '^PECL_ZEND$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${PECL_ZEND_SRC}
    get_file
    unpack

## find php installed dir
    PHP_SYMLINK=$(readlink -f /usr/local/php)
    PHP_DIR=${PHP_SYMLINK:-/usr/local/php}

    INSTALL='install -s -m 0755 php-5.3.x/ZendGuardLoader.so ${PHP_DIR}/ext'
    compile

## record installed tag   
    echo 'PECL_ZEND' >> ${INST_LOG}
fi
