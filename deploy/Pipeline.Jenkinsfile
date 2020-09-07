pipeline {
    agent {
        dockerfile {
            dir 'deploy'
            filename 'Builder.Dockerfile'
            label 'linux && docker'
            additionalBuildArgs '--network host'
            args '-v /tmp:/tmp'
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
                    sh "/bin/true"
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
