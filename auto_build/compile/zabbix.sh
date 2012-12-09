#!/bin/bash
if ! grep '^ZABBIX$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${ZABBIX_SRC}
    get_file
    unpack

    MYSQL_SYMLINK=$(readlink -f /usr/local/mysql)
    MYSQL_DIR=${MYSQL_SYMLINK:-/usr/local/mysql}

## config for zabbix server or proxy
    #CONFIG="./configure --prefix=${INST_DIR}/${SRC_DIR} \
    #--enable-server \
    #--enable-proxy \
    #--enable-agent \
    #--with-mysql=${MYSQL_DIR}/bin/mysql_config \
    #--with-jabber \
    #--with-libcurl"

## config for zabbix agent
    CONFIG="./configure --prefix=${INST_DIR}/${SRC_DIR} --enable-agent"

    LDFLAGS="-L${MYSQL_DIR}/lib -Wl,-rpath,${MYSQL_DIR}/lib"
    CPPFLAGS="-I${MYSQL_DIR}/include"

    if [ "${INST_MODE}" = 'all' ];then

        CURL_SYMLINK=$(readlink -f /usr/local/curl)
        CURL_DIR=${CURL_SYMLINK:-/usr/local/curl}

        ZLIB_SYMLINK=$(readlink -f /usr/local/zlib)
        ZLIB_DIR=${ZLIB_SYMLINK:-/usr/local/zlib}

        OPENSSL_SYMLINK=$(readlink -f /usr/local/openssl)
        OPENSSL_DIR=${OPENSSL_SYMLINK:-/usr/local/openssl}

        LDFLAGS="$LDFLAGS -L${ZLIB_DIR}/lib -L${OPENSSL_DIR}/lib -L${CURL_DIR}/lib -Wl,-rpath,${ZLIB_DIR}/lib -Wl,-rpath,${OPENSSL_DIR}/lib -Wl,-rpath,${CURL_DIR}/lib"
        CPPFLAGS="$CPPFLAGS -I${ZLIB_DIR}/include -I${OPENSSL_DIR}/include -I${CURL_DIR}/include"
    fi

## for compile    
    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/zabbix'
    compile

## clean files
    rm -rf ${INST_DIR}/${SRC_DIR}/share ${INST_DIR}/${SRC_DIR}/etc/*

## for install config files
## for agent
    if [ "${INST_CONF}" -eq 1 ];then
        succ_msg "Begin to install ${SRC_DIR} config files"
        ## user add
        id zabbix >/dev/null 2>&1 || useradd zabbix -u 1003 -M -s /sbin/nologin
        ## log dir
        [ ! -d "/var/log/zabbix" ] && mkdir -m 0755 -p /var/log/zabbix
        chown zabbix:zabbix -R /var/log/zabbix
        ## conf
        install -m 0644 ${TOP_DIR}/conf/zabbix/zabbix_agentd.conf ${INST_DIR}/${SRC_DIR}/etc/zabbix_agentd.conf
        IP_ADDR=$(ip -f inet addr show dev eth0|awk '$1~/inet/{print $2}'|cut -d/ -f1)
        sed -i "s/ListenIP.*/ListenIP=${IP_ADDR}/g" ${INST_DIR}/${SRC_DIR}/etc/zabbix_agentd.conf
        ## init scripts
        install -m 0755 ${TOP_DIR}/conf/zabbix/zabbix_agentd.init /etc/init.d/zabbix_agentd
        chkconfig --add zabbix_agentd
        ## start
        service zabbix_agentd start
    fi

## record installed tag
    echo 'ZABBIX' >> ${INST_LOG}
fi
