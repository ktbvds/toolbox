#!/bin/bash
#### haproxy-1.4.x
if ! grep '^HAPROXY$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${HAPROXY_SRC}
    get_file
    unpack

## for compile
    MAKE="make ARCH=x86_64 PREFIX=${INST_DIR}/${SRC_DIR} install"
    SYMLINK='/usr/local/haproxy'
    compile
    mkdir -m 755 -p ${INST_DIR}/${SRC_DIR}/etc
    rm -rf ${INST_DIR}/${SRC_DIR}/{doc,share}

## for install config files
    if [ "${INST_CONF}" -eq 1 ];then
        succ_msg "Begin to install ${SRC_DIR} config files"
        ## user add
        id haproxy >/dev/null 2>&1 || useradd haproxy -u 1004 -M -s /sbin/nologin
        ## conf
        install -m 0644 ${TOP_DIR}/conf/haproxy/haproxy.cfg ${INST_DIR}/${SRC_DIR}/etc/haproxy.cfg
        ## init scripts
        install -m 0755 ${TOP_DIR}/conf/haproxy/haproxy.init /etc/init.d/haproxy
        chkconfig --add haproxy
        ## start
        service haproxy start
    fi

## record installed tag
    echo 'HAPROXY' >> ${INST_LOG}
fi
