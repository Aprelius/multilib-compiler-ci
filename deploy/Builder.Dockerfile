FROM centos:centos8

RUN set -ex; \
    dnf install -y bzip2 make gcc gcc-c++ libstdc++ curl glibc-devel \
        libstdc++ libstdc++-devel curl-devel openssl openssl-devel \
        wget diffutils; \
    \
    rm -rf /var/cache/dnf; \
    dnf clean all;
