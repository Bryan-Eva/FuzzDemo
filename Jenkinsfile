pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Dockerhub login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                sh '''
                    echo "[*] Logging in to DockerHub as $DOCKER_USER"
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                     docker info | grep Username || echo "[!] Login may have failed."
                '''
                }
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