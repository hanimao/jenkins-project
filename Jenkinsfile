pipeline {
    agent any
    
    environment {
    // AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
    // AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    // AWS_ACCOUNT_ID = ''
        AWS_DEFAULT_REGION = 'eu-west-2'
        IMAGE_NAME = 'jenkins'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Logging into Amazon ECR') {
            steps {
                script {
                        sh "aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 634188077338.dkr.ecr.eu-west-2.amazonaws.com"
                    }
                }
            }
        }

          stage('Checkout Code') {
            steps {
                git 'https://github.com/hanimao/jenkins-project'
            }
        }

          stage('Building Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    // Pushes both the unique build number tag and the 'latest' tag
                    sh "docker push ${REPOSITORY_URI}:latest"
                    sh "docker push ${REPOSITORY_URI}:${IMAGE_TAG}"
                }
            }
        }
        

   post {
        success {
            echo 'Pipeline completed successfully! Application deployed.'
        }
        failure {
            echo 'Pipeline failed! Check logs for details.'
        }
    }
}

    

 