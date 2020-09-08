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
            choices: ['gcc-7', 'gcc-8', 'gcc-9'],
            description: 'Select the toolchain to build'
        )
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
                        cd cmake-build && \
                        ./bootstrap --parallel=4 -- \
                            -DCMAKE_BUILD_TYPE:STRING=Release \
                            -DCMAKE_INSTALL_PREFIX=../cmake-install && \
                        make -j && \
                        make install
                    """
                }
            }
        }
        stage('Build Toolchain') {
            steps {
                script {
                    sh "/bin/true"
                }
            }
        }
        stage('Publish Toolchain') {
            steps {
                script {
                    sh "/bin/true"
                }
            }
        }
    }
    post {
        always {
            echo 'Cleanup docker tags'
        }
        success {
            echo 'Publish pipeline'
        }
        failure {
            echo 'Failed'
        }
    }
}
