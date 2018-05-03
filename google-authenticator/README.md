# ssh 配置谷歌验证码登陆，第一到第三步在root下执行，第四步在需要配置的用户下执行
####################################################################

# 第一步：安装相关依赖包
yum -y install pam-devel libpng-devel qrencode

####################################################################

# 第二步：安装google-authenticator
git clone https://github.com/google/google-authenticator-libpam.git

cd google-authenticator-libpam/
./bootstrap.sh
./configure
make
make install

＃ 安装完成后会在/lib64/security/目录生成pam_google_authenticator.so文件，如果是32位系统会在/lib/security/目录生成。除此之外，系统还会多在/usr/local/bin目录生成一个google－authenticator可执行文件。　如果pam_google_authenticator.so没在正确的位置，把其移动相应位置，比如64位的系统生成的.so错放到了/lib/security/下面

####################################################################

# 第三步：配置sshd
# 修改/etc/pam.d/sshd，添加以下一行，其中nullok表示如果某用户没有配置google-authenticator依然可以用原来的登陆方式登陆，没有nullok则所有用户需要google-authenticator
auth required pam_google_authenticator.so nullok

＃ 修改/etc/ssh/sshd_config，修改为
ChallengeResponseAuthentication yes

# 重启ssh服务
service sshd restart

####################################################################

# 第四步：配置google-authenticator
# 切换到需要配置的账户，运行
google-authenticator

# 会出现二维码链接、图片二维码、应急码等相关提示，用手机端扫描或输入secret key，保存应急码，其他基本默认y就可以了.
# 相应用户再次登陆会出现“Verification code:”的提示，输入手机上的动态码及原来的密码就可以登陆了。
