#!/bin/bash
##squid 2.7

if ! grep '^SQUID$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${SQUID_SRC}
    get_file
    unpack

    CONFIG="./configure --prefix=${INST_DIR}/${SRC_DIR} \
    --enable-xmalloc-statistics \
    --disable-carp \
    --enable-async-io=8 \
    --enable-storeio=aufs,diskd,coss,null,ufs \
    --enable-removal-policies=lru,heap \
    --enable-icmp \
    --enable-delay-pools \
    --enable-useragent-log \
    --enable-useragent-log \
    --disable-wccp \
    --disable-wccpv2 \
    --enable-kill-parent-hack \
    --enable-forward-log \
    --enable-multicast-miss \
    --enable-snmp \
    --enable-cachemgr-hostname=cache.manyou.com \
    --enable-err-languages=English \
    --enable-coss-aio-ops \
    --disable-select \
    --disable-poll \
    --enable-epoll \
    --disable-kqueue \
    --enable-ipf-transparent \
    --enable-large-cache-files \
    --enable-default-hostsfile=/etc/hosts \
    --enable-auth \
    --enable-x-accelerator-vary \
    --enable-follow-x-forwarded-for \
    --with-maxfd=65535 \
    --with-large-files"

    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/squid'
    compile

## for install config files
    if [ "${INST_CONF}" -eq 1 ];then
        succ_msg "Begin to install ${SRC_DIR} config files"
        ## need add
    fi

## record installed tag
    echo 'SQUID' >> ${INST_LOG}
fi