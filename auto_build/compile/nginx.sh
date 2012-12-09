#!/bin/bash
## nginx-1.2.x
if ! grep '^NGINX$' ${INST_LOG} > /dev/null 2>&1 ;then

## nginx 3rd headers plugin
    file_proc ${NGX_HEADER_SRC}
    get_file
    unpack
## nginx
    file_proc ${NGINX_SRC}
    get_file
    unpack

    CONFIG="./configure --prefix=${INST_DIR}/${SRC_DIR} \
            --http-client-body-temp-path=/tmp/client-body-temp \
            --http-proxy-temp-path=/tmp/proxy-temp \
            --http-fastcgi-temp-path=/tmp/fastcgi-temp \
            --http-uwsgi-temp-path=/tmp/uwsgi-temp \
            --http-scgi-temp-path=/tmp/scgi-temp \
            --http-log-path=/var/log/nginx/access.log \
            --error-log-path=/var/log/nginx/error.log \
            --pid-path=/var/run/nginx.pid \
            --lock-path=/var/lock/nginx \
            --user=www \
            --group=www \
            --without-select_module \
            --without-poll_module \
            --with-file-aio \
            --with-http_ssl_module \
            --with-http_realip_module \
            --with-http_stub_status_module \
            --without-mail_pop3_module \
            --without-mail_imap_module \
            --without-mail_smtp_module \
            --add-module=../headers-more-nginx-module-*/"

    if [ "${INST_MODE}" = 'all' ]; then

        OPENSSL_SYMLINK=$(readlink -f /usr/local/openssl)
        OPENSSL_DIR=${OPENSSL_SYMLINK:-/usr/local/openssl}

        ZLIB_SYMLINK=$(readlink -f /usr/local/zlib)
        ZLIB_DIR=${ZLIB_SYMLINK:-/usr/local/zlib}

        PCRE_SYMLINK=$(readlink -f /usr/local/pcre)
        PCRE_DIR=${PCRE_SYMLINK:-/usr/local/pcre}

        CONFIG="${CONFIG} --with-cc-opt=\"-I ${ZLIB_DIR}/include -I ${OPENSSL_DIR}/include -I ${PCRE_DIR}/include\" \
                --with-ld-opt=\"-Wl,-rpath,${ZLIB_DIR}/lib -L ${ZLIB_DIR}/lib -Wl,-rpath,${OPENSSL_DIR}/lib -L ${OPENSSL_DIR}/lib -Wl,-rpath,${PCRE_DIR}/lib -L ${PCRE_DIR}/lib\""

    fi

## for compile
    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/nginx'
    compile

    [ ! -d "${INST_DIR}/${SRC_DIR}/conf/vhosts" ] && mkdir -m 0755 -p ${INST_DIR}/${SRC_DIR}/conf/vhosts

## for install config files
    if [ "${INST_CONF}" -eq 1 ];then
        succ_msg "Begin to install ${SRC_DIR} config files"
        ## user add
        id www >/dev/null 2>&1 || useradd www -u 1001 -M -s /sbin/nologin -d /www/wwwroot
        ## www dir
        [ ! -d "/www/wwwroot" ] && mkdir -m 0755 -p /www/wwwroot
        ## conf
        install -m 0644 ${TOP_DIR}/conf/nginx/nginx.conf ${INST_DIR}/${SRC_DIR}/conf/nginx.conf
        install -m 0644 ${TOP_DIR}/conf/nginx/vhosts.conf ${INST_DIR}/${SRC_DIR}/conf/vhosts/localhost.conf
        install -m 0644 ${TOP_DIR}/conf/nginx/logs.conf ${INST_DIR}/${SRC_DIR}/conf/vhosts/logs.conf
        ## log
        install -m 0644 ${TOP_DIR}/conf/nginx/nginx.logrotate /etc/logrotate.d/nginx
        ## ca scripts
        [ ! -d '/usr/local/sbin' ] && mkdir -p /usr/local/sbin
        install -m 0755 ${TOP_DIR}/conf/nginx/ca.sh /usr/local/sbin/ca.sh
        ## create certs
        /usr/local/sbin/ca.sh
        ## init scripts
        install -m 0755 ${TOP_DIR}/conf/nginx/nginx.init /etc/init.d/nginx
        chkconfig --add nginx
        ## start
        service nginx start
    fi

## record installed tag
    echo 'NGINX' >> ${INST_LOG}
fi
