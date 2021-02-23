#!/bin/sh
TOP=$PWD
CONTAINMENT_DIR=$TOP/nginx-autobuild
SOURCE_DIR=$CONTAINMENT_DIR/nginx
PREFIX=/usr/local/nginx
SBIN_PATH=$PREFIX/sbin
MODULES_PATH=$PREFIX/modules
CONF_PATH=$PREFIX/conf/nginx.conf
ERROR_LOG_PATH=$PREFIX/logs/error.log
PID_PATH=$PREFIX/logs/nginx.pid
LOCK_PATH=$PREFIX/logs/nginx.lock
USER=www-data
GROUP=www-data
BUILDDIR=$SOURCE_DIR/build
LOG_PATH=$PREFIX/logs/access.log
CLIENT_BODY_TEMP_PATH=$PREFIX/client_body_temp
PROXY_TEMP_PATH=$PREFIX/proxy_temp
FAST_CGI_TEMP_PATH=$PREFIX/fastcgi_temp
UWSGI_TEMP_PATH=$PREFIX/uwsgi_temp
SCGI_TEMP_PATH=$PREFIX/scgi_temp

MODULES="--with-threads --with-file-aio --with-http_ssl_module --with-http_v2_module --with-http_sub_module --with-http_dav_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_secure_link_module --with-http_stub_status_module --with-http_perl_module --with-stream --with-stream_ssl_module --with-pcre --with-pcre-jit"

CONFIG_OPTIONS="$MODULES --http-log-path=$LOG_PATH --http-client-body-temp-path=$CLIENT_BODY_TEMP_PATH --prefix=$PREFIX --sbin-path=$SBIN_PATH --modules-path=$MODULES_PATH --conf-path=$CONF_PATH --error-log-path=$ERROR_LOG_PATH --pid-path=$PID_PATH --lock-path=$LOCK_PATH --user=$USER --group=$GROUP --builddir=$BUILDDIR --with-zlib=$SOURCE_DIR/zlib --with-pcre=$SOURCE_DIR/pcre --with-openssl=$SOURCE_DIR/openssl --with-debug --with-cc-opt="-Wno-error=deprecated-declarations""

apt install libtool libperl-dev g++ gcc make subversion mercurial git

mkdir -pv $CONTAINMENT_DIR
cd $CONTAINMENT_DIR
hg clone http://hg.nginx.org/nginx
cd $SOURCE_DIR 
rm -rvf openssl pcre zlib
mkdir -pv $PREFIX 
mkdir -pv $SBIN_PATH
mkdir -pv $MODULES_PATH
mkdir -pv $PREFIX/conf
mkdir -pv $PREFIX/logs

svn co svn://vcs.pcre.org/pcre/code/trunk pcre
git clone https://github.com/openssl/openssl
wget https://www.zlib.net/zlib-1.2.11.tar.gz -O zlib.tar.gz
tar -xvzf zlib.tar.gz
rm zlib.tar.gz
mv -v zlib-* zlib

cd pcre
sh autogen.sh
cd ..
./auto/configure $CONFIG_OPTIONS
make
make install && echo "SUCCESS!"
