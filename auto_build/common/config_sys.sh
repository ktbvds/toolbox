#!/bin/bash

if [ "${INST_CONF}" -eq 1 ];then
    ## config system files
    ## selinux
    sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0

    ## ntp
    install -m 0644 ${TOP_DIR}/conf/ntp/ntp.conf /etc/ntp.conf

    ## add authorized_keys
    useradd -u 2002 -G wheel adam

    for ACCOUNT in adam;do
        echo ismole1110 | passwd --stdin $ACCOUNT
        mkdir -m 0700 /home/$ACCOUNT/.ssh
        install -m 0400 ${TOP_DIR}/conf/pubkeys/${ACCOUNT}.pub /home/$ACCOUNT/.ssh/authorized_keys
        chown ${ACCOUNT}:${ACCOUNT} -R /home/$ACCOUNT/.ssh
    done

    ## sudo
    sed -r -i 's/^#\s(%wheel.*NOPASSWD.*)/\1/g' /etc/sudoers

    ## openssh
    sed -r -i 's/^#?PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config
    sed -r -i 's/^#?PermitEmptyPasswords.*/PermitEmptyPasswords no/g' /etc/ssh/sshd_config
    sed -r -i  's/^#?UseDNS.*/UseDNS no/g' /etc/ssh/sshd_config
    #service sshd restart
    ## profiles
    install -m 0644 ${TOP_DIR}/conf/profile/history.sh /etc/profile.d/history.sh
    install -m 0644 ${TOP_DIR}/conf/profile/path.sh /etc/profile.d/path.sh

    ## sysctl
    install -m 0644 ${TOP_DIR}/conf/sysctl/sysctl.conf /etc/sysctl.conf

    ## timezone
cat > /etc/sysconfig/clock <<EOF
ZONE="Asia/Shanghai"
UTC=true
ARC=false
EOF
    install -m 0755 /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    tzdata-update
    ## config system service

    for SVC in crond ntpd sshd sysstat;do
        service $SRV start
        chkconfig --level 3 4 5 $SRV on
    done

    for SVC in auditd fcoe ip6tables iptables iscsi iscsid lldpad lvm2-monitor netfs nfslock rpcbind rpcgssd rpcidmapd;do
        service $SRV stop
        chkconfig --level 0 1 2 3 4 5 6 $SRV off
    done

fi
