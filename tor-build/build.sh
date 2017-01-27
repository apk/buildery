# apt-get install:
#  gcc make git autoconf automake libevent-dev zlib1g zlib1g-dev libpcre3-dev

set -x

opssl=1.0.2j
opsha256=e7aff292be21c259c6af26469c7a9b3ba26e9abaaffd325e3dccc9785256c431

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
