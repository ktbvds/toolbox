#!/bin/bash
#### mysql-5.5.x
if ! grep '^MYSQL$' ${INST_LOG} > /dev/null 2>&1 ; then

## handle source packages
    file_proc ${MYSQL_SRC}
    get_file
    unpack

    CONFIG="cmake . \
    -DCMAKE_INSTALL_PREFIX:PATH=${INST_DIR}/${SRC_DIR} \
    -DSYSCONFDIR:PATH=/etc \
    -DINSTALL_LAYOUT:STRING=STANDALONE \
    -DMYSQL_DATADIR:PATH=/data/mysql \
    -DINSTALL_SQLBENCHDIR:PATH= \
    -DINSTALL_MYSQLTESTDIR:PATH= \
    -DWITH_ARCHIVE_STORAGE_ENGINE:BOOL=OFF \
    -DWITH_BLACKHOLE_STORAGE_ENGINE:BOOL=OFF \
    -DWITH_CSV_STORAGE_ENGINE:BOOL=OFF \
    -DWITH_EXAMPLE_STORAGE_ENGINE:BOOL=OFF \
    -DWITH_FEDERATED_STORAGE_ENGINE:BOOL=OFF \
    -DWITH_NDBCLUSTER_STORAGE_ENGINE:BOOL=OFF \
    -DWITH_MYISAM_STORAGE_ENGINE:BOOL=ON \
    -DWITH_INNOBASE_STORAGE_ENGINE:BOOL=ON \
    -DWITH_PARTITION_STORAGE_ENGINE:BOOL=ON \
    -DWITH_PERFSCHEMA_STORAGE_ENGINE:BOOL=ON \
    -DDEFAULT_CHARSET:STRING=utf8 \
    -DDEFAULT_COLLATION:STRING=utf8_general_ci \
    -DWITH_EXTRA_CHARSETS:STRING=all \
    -DENABLED_LOCAL_INFILE:BOOL=ON \
    -DENABLED_PROFILING:BOOL=ON \
    -DMYSQL_TCP_PORT:STRING=3306 \
    -DMYSQL_UNIX_ADDR:STRING=/tmp/mysql.sock \
    -DWITH_EMBEDDED_SERVER:BOOL=OFF \
    -DWITH_LIBWRAP:BOOL=ON \
    -DWITH_READLINE:BOOL=ON \
    -DWITH_SSL:STRING=no \
    -DWITH_ZLIB:STRING=system \
    -DWITH_DEBUG:BOOL=OFF"

    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/mysql'

    compile

## clean files    
    rm -rf ${INST_DIR}/${SRC_DIR}/{data,docs,man,mysql-test,sql-bench,support-files,COPYING,INSTALL-BINARY,README}
    rm -rf  ${INST_DIR}/${SRC_DIR}/bin/{msql2mysql,mysqltest,mysqlslap}
    find ${INST_DIR}/${SRC_DIR}/lib -name *.a | xargs rm -f

    #ln -sf ${INST_DIR}/${SRC_DIR}/include  /usr/include/mysql
    #ln -sf ${INST_DIR}/${SRC_DIR}/lib/*    /usr/lib64/

## for install config files
    if [ "${INST_CONF}" -eq 1 ];then
        succ_msg "Begin to install ${SRC_DIR} config files"
        ## user add
        id mysql >/dev/null 2>&1 || useradd mysql -u 1002 -M -s /sbin/nologin -d /var/lib/mysql
        ## data dir
        [ ! -d "/var/lib/mysql" ] && mkdir -m 0700 -p /var/lib/mysql
        chown mysql:mysql -R /var/lib/mysql
        ## conf
        SERVER_ID=$(ip -f inet addr show dev eth0|awk '$1~/inet/{print $2}'|cut -d/ -f1|tr -d .)
        install -m 0644 --backup=numbered ${TOP_DIR}/conf/mysql/my.cnf /etc/my.cnf
        sed -i "s/server-id.*/server-id=${SERVER_ID}/" /etc/my.cnf 
        ## backup
        install -m 0755 ${TOP_DIR}/conf/mysql/backup_mysql.sh /usr/local/sbin/backup_mysql.sh
        ## log
        mkdir -m 0755 /var/log/mysql
        chowm mysql:mysql -R /var/log/mysql
        install -m 0644 ${TOP_DIR}/conf/mysql/mysql.logrotate /etc/logrotate.d/mysql
        ## init scripts
        install -m 0755 ${TOP_DIR}/conf/mysql/mysql.init /etc/init.d/mysqld
        chkconfig --add mysqld
        ## start
        service mysqld start
    fi
## record installed tag
    echo 'MYSQL' >> ${INST_LOG}
fi
