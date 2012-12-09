#!/bin/bash
## backup dir like /backup/mysql/2012080803/dbname/tablename.sql and compress all databases to /backup/mysql/2012080803.tgz
#set -x
set -u

export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/sbin:/usr/local/mysql/bin
export HOME=/var/empty

DATE=$(date +%Y%m%d-%H-%M)

DB_USER=root
#set password with puppet
DB_PASS=<%= mysql_pass %>
DB_HOST=localhost
BACKUP_DIR='/backup/mysql'

[ ! -d ${BACKUP_DIR} ] && mkdir -p ${BACKUP_DIR}

## run logs
exec > ${BACKUP_DIR}/${DATE}-mysql_dump.log 2>&1

## collect tables information
mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} -e "select TABLE_SCHEMA,TABLE_NAME from information_schema.TABLES where  TABLE_SCHEMA not in ('performance_schema','information_schema');" -s -N > ${BACKUP_DIR}/sql_tables_name.log

## dump sql
while read LINE
do
    DB_NAME=$(echo $LINE|awk '{print $1}')
    TABLE_NAME=$(echo $LINE|awk '{print $2}')

    [ ! -d "${BACKUP_DIR}/$DATE/${DB_NAME}" ] && mkdir -p "${BACKUP_DIR}/$DATE/${DB_NAME}"
    mysqldump -u$DB_USER -p$DB_PASS -h$DB_HOST --opt --single-transaction $DB_NAME $TABLE_NAME > ${BACKUP_DIR}/$DATE/${DB_NAME}/${TABLE_NAME}.sql

done < ${BACKUP_DIR}/sql_tables_name.log

## compress
cd ${BACKUP_DIR} && tar zcPf $DATE.tgz $DATE  && rm -rf $DATE

#find ${BACKUP_DIR} -maxdepth 1 -mtime +5 -type f | xargs rm -rf
