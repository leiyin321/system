#!/bin/bash
yum -y install git pam-devel libpng-devel qrencode autoconf automake libtool
git clone https://github.com/google/google-authenticator-libpam.git
cd google-authenticator-libpam/
./bootstrap.sh
./configure
make
make install
cp /usr/local/lib/security/pam_google_authenticator.so /lib64/security/

# 第三步：配置sshd
# 修改/etc/pam.d/sshd，添加以下一行，其中nullok表示如果某用户没有配置google-authenticator依然可以用原来的登陆方式登陆，没有nullok则所有用户需要google-authenticator
#auth required pam_google_authenticator.so nullok

# 修改/etc/ssh/sshd_config，修改为
#ChallengeResponseAuthentication yes

