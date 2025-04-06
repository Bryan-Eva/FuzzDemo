pipeline {
    agent any

    stages {
        stage('Set Permissions') {
            steps {
                sh 'chmod +x tools/fuzz_framework/build.sh'
                sh 'chmod +x tools/fuzz_framework/run_fuzz.sh'
            }
        }

        stage('Run Fuzzer') {
            steps {
                sh './tools/fuzz_framework/run_fuzz.sh'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'tools/fuzz_framework/logs/**/*.txt', fingerprint: true
        }
    }
}