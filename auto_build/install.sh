#!/bin/bash
################################################
## CentOS 6.2-x86_64 / 6.3-x86_64 Test Passed
################################################
#set -x
#set -u
#set -e
## Pre-set Global readonly variables
readonly TOP_DIR="$(cd $(dirname $0);pwd)"
## Set logs
#exec 1>${TOP_DIR}/stdout.log
#exec 2>${TOP_DIR}/stderr.log
## Global readonly variables
readonly VER=1.0
readonly DATE=$(date +%Y%m%d-%H-%M)
readonly ARCH=$(uname -i)
readonly STORE_DIR="${TOP_DIR}/src"
readonly INST_DIR='/usr/local/services'
readonly INST_LOG="${TOP_DIR}/install.log"
readonly DOWN_URL='http://down.l09.me/packages'
readonly CHECK_MD5=1
readonly INST_CONF=1
readonly HOME='/var/empty'
readonly PATH='/usr/bin:/bin:/usr/sbin:/sbin'

## Shell Environment
export HOME PATH
alias cp='cp'
alias mv='mv'
alias rm='rm'
alias grep='grep --color'
## Include share functions
source ${TOP_DIR}/common/functions.sh

## Check root privilege
[ $(id -u) -ne 0 ] && fail_msg "Need root privilege"
## Check architecture
[ "$ARCH" != 'x86_64' ] && fail_msg "Not support $ARCH,please use x86_64"
## Check OS distro
OS_VER=$(awk '$1~/CentOS/{print $3}' /etc/issue | cut -d. -f1)
[ "${OS_VER}" -lt 6 ] && fail_msg "Not support OS version : ${OS_VER}, please use CentOS-6.x-x86_64"

## INST_FLAG = install or reinstall , install is default
## INST_MODE = standard or all , standard is default
INST_FLAG=${1:-install}
INST_MODE=${2:-standard}

case ${INST_FLAG} in
    install)
        succ_msg "=============== install ================="
        touch ${INST_LOG}
        ;;
    reinstall)
        succ_msg "=============== reinstall ==============="
        succ_msg "Clean ${INST_LOG}"
        echo '' > ${INST_LOG}
        [ -d "${INST_DIR}" ] && mv ${INST_DIR} ${INST_DIR}-$DATE
        ;;
    *)
        warn_msg "Not support the install flag : ${INST_FLAG}"
        fail_msg "Usage: $0 [ install | reinstall ] | [ standard | all ]"
        ;;
esac

if [ "${INST_MODE}" != 'standard' -a "${INST_MODE}" != 'all' ];then
    warn_msg "Not support the install mode : ${INST_MODE}"
    fail_msg "Usage: $0 [ install | reinstall ] | [ standard | all ]"
fi

## Check source store dir
[ ! -d "${STORE_DIR}" ] && mkdir -p "${STORE_DIR}" || find ${STORE_DIR}/* -maxdepth 1 -type d | xargs rm -rf

## Install development libs
source ${TOP_DIR}/common/install_dev.sh

## Config System
source ${TOP_DIR}/common/config_sys.sh

## Import packages source list
source ${TOP_DIR}/file.lst

## Build development library
if [ "${INST_MODE}" = 'all' ];then
    source ${TOP_DIR}/compile/zlib.sh
    source ${TOP_DIR}/compile/openssl.sh
    source ${TOP_DIR}/compile/cares.sh
    source ${TOP_DIR}/compile/curl.sh
    source ${TOP_DIR}/compile/libxml2.sh
    source ${TOP_DIR}/compile/pcre.sh
    source ${TOP_DIR}/compile/libevent.sh
#    source ${TOP_DIR}/compile/freetype.sh
#    source ${TOP_DIR}/compile/libjpeg.sh
#    source ${TOP_DIR}/compile/libpng.sh
#    source ${TOP_DIR}/compile/gd2.sh
fi
## High availability for lvs/haproxy/nginx and so on
#source ${TOP_DIR}/compile/keepalived.sh

## 4-layer and 7-layer reverse proxy
#source ${TOP_DIR}/compile/haproxy.sh

## web server or 7-layer reverse proxy
source ${TOP_DIR}/compile/nginx.sh
#source ${TOP_DIR}/compile/httpd.sh
#source ${TOP_DIR}/compile/lighttpd.sh

## MySQL
source ${TOP_DIR}/compile/mysql.sh
## MySQL - percona-xtrabackup - binary backup tool
source ${TOP_DIR}/compile/xtrabackup.sh

## NoSQL
#source ${TOP_DIR}/compile/libmemcached.sh
#source ${TOP_DIR}/compile/memcached.sh
#source ${TOP_DIR}/compile/tokyocabinet.sh
#source ${TOP_DIR}/compile/tokyotyrant.sh
source ${TOP_DIR}/compile/redis.sh
source ${TOP_DIR}/compile/moxi.sh

## php
source ${TOP_DIR}/compile/php.sh
source ${TOP_DIR}/compile/pecl_apc.sh
#source ${TOP_DIR}/compile/pecl_memcache.sh
#source ${TOP_DIR}/compile/pecl_redis.sh
#source ${TOP_DIR}/compile/pecl_couchbase.sh
#source ${TOP_DIR}/compile/pecl_memcached.sh
#source ${TOP_DIR}/compile/pecl_xcache.sh
#source ${TOP_DIR}/compile/pecl_xdebug.sh
## zabbix monitor
source ${TOP_DIR}/compile/zabbix.sh

## Close io redirection
#exec 1>&-
#exec 2>&-

## Print end message
succ_msg 'Packages build finish'
