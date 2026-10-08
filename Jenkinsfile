pipeline {
    agent any

    environment {
        IMAGE_NAME = "bhuvnesh15/jenkins-docker-cicd"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Building application...'
                sh 'ls -la'
            }
        }

        stage('Test') {
            steps {
                echo 'Running automated test...'
                sh 'test -f index.html'
                echo 'TEST PASSED: index.html exists'
            }
        }

        stage('Package') {
            steps {
                echo 'Packaging application...'
                sh 'mkdir -p package'
                sh 'cp index.html package/index.html'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building container image...'
                sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
                sh 'docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest'
            }
        }

        stage('Docker Push') {
            steps {
                echo 'Pushing image to Docker Hub...'

                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        export XDG_RUNTIME_DIR=/run/user/978

                        echo "$DOCKER_PASSWORD" | podman login docker.io \
                            --username "$DOCKER_USER" \
                            --password-stdin

                        podman push \
                            localhost/$IMAGE_NAME:$IMAGE_TAG \
                            docker://docker.io/$IMAGE_NAME:$IMAGE_TAG

                        podman push \
                            localhost/$IMAGE_NAME:latest \
                            docker://docker.io/$IMAGE_NAME:latest

                        podman logout docker.io
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'CI/CD Pipeline completed successfully!'
        }

        failure {
            echo 'CI/CD Pipeline failed.'
        }
    }
}
