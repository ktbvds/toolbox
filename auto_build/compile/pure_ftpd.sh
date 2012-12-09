#!/bin/bash
if ! grep '^PURE_FTPD$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${PURE_FTPD_SRC}
    get_file
    unpack

    CONFIG="./configure --prefix=${INST_DIR}/${SRC_DIR} \
            --without-inetd \
            --with-altlog \
            --with-puredb \
            --with-throttling \
            --with-ratios \
            --with-peruserlimits \
            --with-language=english \
            --with-tls \
            --with-certfile=${INST_DIR}/${SRC_DIR}/etc/pure-ftpd.pem \
            --with-rfc2640"

    ## for compile 
    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/pure-ftpd'
    compile

    ## for install config files
    if [ "${INST_CONF}" -eq 1 ];then
        succ_msg "Begin to install ${SRC_DIR} config files"
        ## need add sometings
    fi

## record installed tag    
    echo 'PURE_FTPD' >> ${INST_LOG}
fi
