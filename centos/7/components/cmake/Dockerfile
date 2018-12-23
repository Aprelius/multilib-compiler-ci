FROM centos:centos7

ENV CMAKE_VERSION 3.13.2
ENV CMAKE_URL https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.tar.gz

RUN set -ex; \
    yum update -y; \
    yum install -y make gcc gcc-c++ libstdc++ curl-devel openssl-devel; \
    yum clean all; \
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