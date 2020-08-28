pipeline {
    agent { label 'linux && docker' }

    parameters {
        choice(
            name: 'OS_NAME',
            choices: ['centos'],
            description: 'Operation system to build from'
        )
        choice(
            name: 'OS_VERSION',
            choices: ['7', '8'],
            description: 'Operating system version to source from'
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
        stage('Build Container') {
            steps {
                script {
                    sh """
                        docker build --network=host -f \
                            ${params.OS_NAME}/${params.OS_VERSION}/toolchains/${params.TOOLCHAIN}/Dockerfile \
                            .
                    """
                }
            }
        }
    }
}