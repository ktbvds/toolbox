#!/bin/bash
#### percona-xtrabackup-2.0.0.tar.gz 
if ! grep '^XTRABACKUP$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages  
    file_proc ${XTRABACKUP_SRC}
    get_file
    unpack
    INSTALL="cp -rf ${STORE_DIR}/${SRC_DIR} ${INST_DIR}"
    SYMLINK='/usr/local/percona-xtrabackup'
	compile

## clean files
    rm -rf ${INST_DIR}/${SRC_DIR}/share

## record installed tag
    echo 'XTRABACKUP' >> ${INST_LOG}
fi
