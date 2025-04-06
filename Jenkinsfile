pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
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