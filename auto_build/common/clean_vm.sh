#!/bin/bash
service rsyslog stop
find /var/log -type f |xargs rm -f 
rm -rf /root/*
rm -rf /tmp/*
rm -f /etc/ssh/ssh_host_*
rm -f /etc/udev/rules.d/70-persistent-net.rules
