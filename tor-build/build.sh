# apt-get install:
#  gcc make git autoconf automake libevent-dev zlib1g zlib1g-dev libpcre3-dev

set -x

opssl=1.0.2n
opsha256=370babb75f278c39e0c50e8c4e7493bc0f18db6867478341a832a982fd15a8fe

test -r openssl-$opssl.tar.gz || \
  wget http://www.openssl.org/source/openssl-$opssl.tar.gz || exit 1

sha256=`sha256sum openssl-$opssl.tar.gz | awk '{print $1}'`

test X"$sha256" = X$opsha256 || exit 1

P=`pwd`/local

if test X"`test -s sslvers && cat sslvers`" != X"$opssl"; then

   rm -rf openssl-$opssl "$P"
   tar xzf openssl-$opssl.tar.gz || exit 1
   (cd openssl-${opssl} && \
      ./config --shared --prefix=$P && \
      make && \
      make install
   ) || exit 1

   echo "$opssl" > sslvers

fi

test -d tor || git clone -b currents/rel https://github.com/apk/tor.git || exit 1

(cd tor && \
   git clean -fdx && \
   sh autogen.sh && \
   ./configure --prefix=$HOME/tor-local --with-openssl-dir=$P --disable-asciidoc && \
   make
) || exit 1

mkdir -p out || exit 1
cp tor/src/app/tor out/tor.new || exit 1
mv out/tor.new out/tor || exit 1

echo ok

exit
