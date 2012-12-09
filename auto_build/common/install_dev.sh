#!/bin/bash

install -m 0644 ${TOP_DIR}/conf/yum/CentOS-Base.repo  /etc/yum.repos.d/CentOS-Base.repo
install -m 0644 ${TOP_DIR}/conf/yum/epel.repo /etc/yum.repos.d/epel.repo
install -m 0644 ${TOP_DIR}/conf/yum/puppetlabs.repo /etc/yum.repos.d/puppetlabs.repo

install -m 0644 ${TOP_DIR}/conf/yum/RPM-GPG-KEY-EPEL-6 /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
install -m 0644 ${TOP_DIR}/conf/yum/RPM-GPG-KEY-puppetlabs /etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs

yum update -y
yum install -y $(cat <<EOF
autoconf
automake
bash-completion
bind-utils
binutils
bison
blktrace
byacc
bzip2-devel
c-ares-devel
cmake
crontabs
cyrus-sasl-devel
db4-devel
db4-utils
dos2unix
dstat
elinks
expect
file
flex
gcc
gcc-c++
glibc-devel
gnupg2
iotop
iptraf
jwhois
lftp
libaio-devel
libcurl-devel
libevent-devel
libmcrypt-devel
libnl-devel
libstdc++-devel
libtool
libtool-ltdl-devel
libxml2-devel
libxslt-devel
logrotate
lrzsz
lsof
make
man
man-pages
man-pages-overrides
mlocate
mtr
ntp
ntpdate
openssh-clients
openssl-devel
patch
patchutils
pciutils
pcre-devel
popt-devel
protobuf-c-devel
protobuf-devel
puppet
readline-devel
rsync
screen
strace
sudo
sysstat
tcpdump
telnet
time
traceroute
tree
unzip
vim-enhanced
wget
which
xz-devel
zip
zlib-devel
EOF
)