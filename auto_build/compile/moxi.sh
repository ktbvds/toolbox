#!/bin/bash
#moxi-1.8.1
if ! grep '^MOXI$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages    
    file_proc ${MOXI_SRC}
    get_file
    
    rpm -ivh ${STORE_DIR}/$SRC && ln -s /opt/moxi /usr/local/moxi

## for install config files
    if [ "${INST_CONF}" -eq 1 ];then
        succ_msg "Begin to install ${SRC_DIR} config files"
        ## user add
        id moxi >/dev/null 2>&1 || useradd moxi -u 1006 -M -s /sbin/nologin
        ## conf
        install -m 0644 ${TOP_DIR}/conf/moxi/moxi.conf /opt/moxi/etc/moxi.conf
        install -m 0644 ${TOP_DIR}/conf/moxi/moxi-cluster.conf /opt/moxi/etc/moxi-cluster.conf
        ## init scripts
        install -m 0755 ${TOP_DIR}/conf/moxi/moxi-server.init /etc/init.d/moxi-server
        chkconfig --add moxi-server
        ## start
        service moxi-server start
    fi

## record installed tag    
    echo 'MOXI' >> ${INST_LOG}
fi
