FROM centos:centos8 AS cmake-build

ENV CMAKE_VERSION 3.17.2
ENV CMAKE_URL https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.tar.gz

RUN set -ex; \
    dnf update -y; \
    dnf install -y make gcc gcc-c++ libstdc++ curl-devel openssl-devel; \
    dnf clean all; \
    rm -rf /var/cache/dnf; \
    \
    _fetch() { \
        local fetch="$1"; shift; \
        local file="$1"; shift; \
        if curl -fL "$fetch" -o "$file"; then \
            return 0; \
        fi; \
        echo >&2 "error: failed to download '$fetch' from mirror"; \
        return 1; \
    }; \
    \
    _fetch "$CMAKE_URL" 'cmake.tar.gz'; \
    mkdir -p /usr/src/cmake; \
    tar xzf cmake.tar.gz -C /usr/src/cmake --strip-components=1; \
    rm cmake.tar.gz; \
    cd /usr/src/cmake; \
    \
    /usr/src/cmake/bootstrap -- -DCMAKE_BUILD_TYPE:STRING=Release; \
    make -j "$(nproc)"; \
    make install; \
    \
    cd ..; \
    rm -rf /usr/src/cmake;

FROM centos:centos8 AS gcc-build
ENV GCC_MAJOR_VERSION 9
ENV GCC_VERSION 9.3.0
ENV GCC_MIRROR https://ftpmirror.gnu.org/gcc

RUN set -ex; \
  dnf update -y; \
  dnf install -y bzip2 make gcc gcc-c++ libstdc++ libstdc++-devel \
    libstdc++.i686 libstdc++-devel.i686 glibc glibc-devel glibc.i686 glibc-devel.i686 \
    wget curl; \
  dnf clean all; \
  rm -rf /var/cache/dnf; \
  \
  _fetch() { \
    local fetch="$1"; shift; \
    local file="$1"; shift; \
    if curl -s -fL "$GCC_MIRROR/$fetch" -o "$file"; then \
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
  rm -rf /usr/src/gcc;

FROM centos:centos8

ENV GCC_MAJOR_VERSION 9
ENV GCC_VERSION 9.3.0

COPY --from=cmake-build /usr/local/bin/cmake /usr/local/bin/cmake
COPY --from=cmake-build /usr/local/bin/cpack /usr/local/bin/cpack
COPY --from=cmake-build /usr/local/bin/ctest /usr/local/bin/ctest
COPY --from=cmake-build /usr/local/share/cmake-3.17 /usr/local/share/cmake-3.17

COPY --from=gcc-build /usr/local/bin/gcc /usr/local/bin/gcc
COPY --from=gcc-build /usr/local/bin/g++ /usr/local/bin/g++
COPY --from=gcc-build /usr/local/lib /usr/local/lib
COPY --from=gcc-build /usr/local/lib64 /usr/local/lib64
COPY --from=gcc-build /usr/local/include /usr/local/include
COPY --from=gcc-build /usr/local/libexec /usr/local/libexec
COPY --from=gcc-build /usr/local/share/gcc-${GCC_VERSION} /usr/local/share

RUN set -ex; \
    dnf update -y; \
    dnf install -y make glibc-devel glibc-devel.i686 \
        perl curl-devel; \
    dnf clean all; \
    rm -rf /var/cache/dnf; \
    \
    echo '/usr/local/lib64' > /etc/ld.so.conf.d/local-lib64.conf; \
    echo '/usr/local/lib' > /etc/ld.so.conf.d/local-lib.conf; \
    ldconfig -v; \
    \
    ln -s /usr/local/bin/gcc "/usr/bin/gcc${GCC_MAJOR_VERSION}"; \
    ln -s /usr/local/bin/g++ "/usr/bin/g++${GCC_MAJOR_VERSION}";
