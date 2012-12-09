#!/bin/bash
if ! grep '^PECL_COUCHBASE$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${PECL_COUCHBASE_SRC}
    get_file
    unpack

## find php installed dir
    PHP_SYMLINK=$(readlink -f /usr/local/php)
    PHP_DIR=${PHP_SYMLINK:-/usr/local/php}

    cd ${STORE_DIR} && install -s -m 0755 php-ext-couchbase/couchbase.so ${PHP_DIR}/ext

## record installed tag
    echo 'PECL_COUCHBASE' >> ${INST_LOG}
fi
