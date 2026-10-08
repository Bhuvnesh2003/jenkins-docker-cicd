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
            '''
        }
    }
}
