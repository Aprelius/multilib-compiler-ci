FROM centos:centos7

ENV GCC_VERSION 7.3.0
ENV GCC_MIRROR https://ftpmirror.gnu.org/gcc

RUN set -ex; \
  yum update -y; \
  yum install -y python bzip2 make gcc gcc-c++ gcc-multilib libstdc++ libstdc++-devel \
    libstdc++.i686 libstdc++-devel.i686 glibc glibc-devel glic.i686 glibc-devel.i686; \
  yum clean all; \
  \
  _fetch() { \
    local fetch="$1"; shift; \
    local file="$1"; shift; \
    if curl -fL "$GCC_MIRROR/$fetch" -o "$file"; then \
      return 0; \
    fi; \
    echo >&2 "error: failed to download '$fetch' from mirror"; \
    return 1; \
  }; \
  \
  _fetch "gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz" 'gcc.tar.xz'; \
  mkdir -p /usr/src/gcc; \
  tar -xf gcc.tar.xz -C /usr/src/gcc --strip-components=1; \
  rm gcc.tar.xz*; \
  \
  cd /usr/src/gcc; \
  \
  ./contrib/download_prerequisites; \
  { rm *.tar.* || true; }; \
  \
  dir="$(mktemp -d)"; \
  cd "$dir"; \
  \
  /usr/src/gcc/configure \
    --prefix=/usr/local \
    --enable-languages=c,c++ \
    --enable-multilib \
    --enable-clocale=gnu \
    --enable-shared \
    --enable-threads=posix \
    --enable-__cxa_atexit; \
  \
  make -j "$(nproc)"; \
  make install-strip; \
  \
  cd ..; \
  \
  rm -rf "$dir"; \
  rm -rf /usr/src/gcc; \
  yum clean all;

RUN set -ex; \
  echo '/usr/local/lib64' > /etc/ld.so.conf.d/local-lib64.conf; \
  echo '/usr/local/lib' > /etc/ld.so.conf.d/local-lib.conf; \
  ldconfig -v

