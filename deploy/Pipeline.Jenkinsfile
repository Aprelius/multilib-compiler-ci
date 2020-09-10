pipeline {
    agent {
        dockerfile {
            customWorkspace "workspace/${env.JOB_NAME}/${env.BUILD_NUMBER}"
            dir 'deploy'
            filename 'Builder.Dockerfile'
            label 'linux && docker'
            additionalBuildArgs '--network host'
            args '--network host'
        }
    }

    parameters {
        choice(
            name: 'CMAKE_VERSION',
            choices: ['3.17.2', '3.17.4', '3.18.2'],
            description: 'Version of CMake to build for the toolchain'
        )
        choice(
            name: 'TOOLCHAIN',
            choices: ['gcc'],
            description: 'Select the toolchain to build'
        )
        choice(
            name: 'GCC_VERSION',
            choices: ['7.5.0', '8.4.0', '9.3.0'],
            description: 'GCC Version to build'
        )
        string(
            name: 'DOCKER_REGISTRY',
            defaultValue: '',
            description: 'Docker registry for publishing completed toolchains')
    }

    stages {
        stage('Validate parameters') {
            steps {
                script {
                    sh "/bin/true"
                }
            }
        }
        stage('Build CMake') {
            steps {
                script {
                    sh """
                        curl -fL \
                            https://github.com/Kitware/CMake/releases/download/v${params.CMAKE_VERSION}/cmake-${params.CMAKE_VERSION}.tar.gz \
                            -o cmake.tar.gz
                    """
                    sh "mkdir -p cmake-build cmake-install"
                    sh """
                        tar xzf \
                            cmake.tar.gz \
                            -C cmake-build \
                            --strip-components=1
                    """
                    sh """
                        set -ex; \
                        cd cmake-build; \
                        ./bootstrap --parallel=4 -- \
                            -DCMAKE_BUILD_TYPE:STRING=Release \
                            -DCMAKE_INSTALL_PREFIX=../cmake-install && \
                        make -j4; \
                        make install;
                    """
                }
            }
        }
        stage('Build Toolchain') {
            steps {
                script {
                    sh """
                        curl -fL \
                            https://ftpmirror.gnu.org/gcc/gcc-${params.GCC_VERSION}/gcc-${params.GCC_VERSION}.tar.xz \
                            -o gcc.tar.xz
                    """
                    sh "mkdir -p gcc-build/build gcc-install"
                    sh """
                        tar xf \
                            gcc.tar.xz \
                            -C gcc-build \
                            --strip-components=1
                    """
                    sh """
                        set -ex; \
                        cd gcc-build; \
                        ./contrib/download_prerequisites; \
                        { rm *.tar.* || true; }; \
                        cd build; \
                        ../configure \
                            --prefix=${WORKSPACE}/gcc-install \
                            --disable-multilib \
                            --enable-languages=c,c++ \
                            --enable-clocale=gnu \
                            --enable-shared \
                            --enable-threads=posix \
                            --enable-__cxa_atexit; \
                        make -j4; \
                        make install-strip;
                    """
                }
            }
        }
        stage('Publish Toolchain') {
            agent none
            steps {
                script {
                    gitCommit = sh(
                            returnStdout: true,
                            script: 'git rev-parse HEAD'
                        ).trim()
                    gitCommitShort = gitCommit.substring(0, 10)
                }

                sh """
                    docker build \
                        --network host \
                        -t ${params.DOCKER_REGISTRY}/toolchains/${params.TOOLCHAIN}-${params.GCC_VERSION}:${gitCommitShort}
                        -f toolchains/${params.TOOLCHAIN}/Dockerfile \
                        .
                """
                sh """
                    docker push \
                        ${params.DOCKER_REGISTRY}/toolchains/${params.TOOLCHAIN}-${params.GCC_VERSION}:${gitCommitShort}
                """
                sh """
                    docker image rm \
                        ${params.DOCKER_REGISTRY}/toolchains/${params.TOOLCHAIN}-${params.GCC_VERSION}:${gitCommitShort}
                """
            }
        }
    }
    post {
        always {
            echo 'Cleanup docker tags'
            echo 'Cleanup build folders'
            sh 'rm -rf gcc-build cmake-build'
        }
    }
}
