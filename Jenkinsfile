pipeline {
    agent any

    environment {
        PROJECT_NAME = "fuzzdemo"
    }

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
            // archiveArtifacts artifacts: 'tools/fuzz_framework/logs/**/*.txt', fingerprint: true
            sh 'cat /tmp/build_invoked.txt || echo "build.sh not exec!"'
        }
    }
}