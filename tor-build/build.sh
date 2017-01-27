# apt-get install:
#  gcc make git autoconf automake libevent-dev zlib1g zlib1g-dev libpcre3-dev

set -x

opssl=1.0.2k
opsha256=6b3977c61f2aedf0f96367dcfb5c6e578cf37e7b8d913b4ecb6643c3cb88d8c0

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

test -d tor || git clone -b release-0.2.9 https://git.torproject.org/tor.git || exit 1

(cd tor && \
   git clean -fdx && \
   sh autogen.sh && \
   ./configure --prefix=$HOME/tor-local --with-openssl-dir=$P --disable-asciidoc && \
   make
) || exit 1

exit
