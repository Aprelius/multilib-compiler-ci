FROM centos:centos8

RUN set -ex; \
    dnf update -y; \
    dnf install -y make glibc-devel glibc-devel.i686 \
        perl python3 python3-pip curl-devel git; \
    dnf clean all; \
    rm -rf /var/cache/dnf; \
    \
    python3 -m pip install --upgrade pip; \
    python3 -m pip install urllib3 requests; \
    rm -rf /root/.cache/pip; \
    ln -s /usr/bin/python3 /usr/local/bin/python;

# Copy the CMake built assets into the container. We have
# to include the executables and the shared files for CMake
# to function correctly.
COPY [ \
    "cmake-install/bin/cmake", \
    "cmake-install/bin/cpack", \
    "cmake-install/bin/ctest", \
    "/usr/local/bin/"]
COPY [ \
    "cmake-install/share/", \
    "/usr/local/share/"]

# Copy the GCC bult assets into the container. We need to
# include everythign to ensure we get the full libstdc++
# and all of the components
COPY [ \
    "gcc-build/bin/gcc", \
    "gcc-build/bin/g++", \
    "gcc-build/bin/gcc-ar", \
    "gcc-build/bin/gcc-gcov", \
    "gcc-build/bin/gcc-nm", \
    "gcc-build/bin/gcov", \
    "gcc-build/bin/gcov-dump", \
    "gcc-build/bin/gcov-tool", \
    "/usr/local/bin/"]
COPY [ \
    "gcc-build/lib", \
    "gcc-build/lib64", \
    "gcc-build/include", \
    "gcc-build/libexec", \
    "gcc-build/share", \
    "/usr/local/"]

# Run the ldconfig command last to ensure the new GCC libraries
# are picked up correctly.
RUN set -x; \
    echo '/usr/local/lib64' > /etc/ld.so.conf.d/local-lib64.conf; \
    echo '/usr/local/lib' > /etc/ld.so.conf.d/local-lib.conf; \
    ldconfig -v;