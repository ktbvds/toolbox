#!/bin/bash
#### redis-2.4.x
if ! grep '^REDIS$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${REDIS_SRC}
    get_file
    unpack

## for compile
    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/redis'
    sed -ri "s#^PREFIX.*#PREFIX=${INST_DIR}/${SRC_DIR}#" ${STORE_DIR}/${SRC_DIR}/src/Makefile
    compile
    
    mkdir ${INST_DIR}/${SRC_DIR}/etc

## for install config files
    if [ "${INST_CONF}" -eq 1 ];then
        succ_msg "Begin to install ${SRC_DIR} config files"
        ## user add
        id redis >/dev/null 2>&1 || useradd redis -u 1005 -M -s /sbin/nologin -d /var/lib/redis
        ## data dir 
        [ ! -d "/var/lib/redis" ] && mkdir -m 0755 -p /var/lib/redis
        chown redis:redis -R /var/lib/redis
        ## log dir
        [ ! -d "/var/log/redis" ] && mkdir -m 0755 -p /var/log/redis
        chown redis:redis -R /var/log/redis
        ## conf
        install -m 0644 ${TOP_DIR}/conf/redis/redis.conf ${INST_DIR}/${SRC_DIR}/etc/redis.conf
        ## init scripts
        install -m 0755 ${TOP_DIR}/conf/redis/redis.init /etc/init.d/redis
        chkconfig --add redis
        ## start
        service redis start
    fi

## record installed tag
    echo 'REDIS' >> ${INST_LOG}
fi
