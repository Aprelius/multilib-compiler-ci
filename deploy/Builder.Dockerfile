FROM centos:centos8

RUN set -ex; \
    dnf install -y make gcc gcc-c++ libstdc++ curl \
        curl-devel openssl openssl-devel; \
    \
    rm -rf /var/cache/dnf; \
    dnf clean all;