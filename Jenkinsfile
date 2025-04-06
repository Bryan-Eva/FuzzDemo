pipeline {
    agent {
        docker {
            image 'python:3.8-slim'
            args '-u root'
        }
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                  apt-get update && apt-get install -y git
                  pip install --upgrade pip
                  pip install atheris
                '''
            }
        }

        stage('Run ClusterFuzz') {
            steps {
                sh 'chmod +x tools/fuzz_framework/run_fuzz.sh'
                sh 'tools/fuzz_framework/run_fuzz.sh'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'tools/fuzz_framework/logs/*.log', fingerprint: true
        }
    }
}