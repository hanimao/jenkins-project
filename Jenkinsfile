pipeline {
    agent any
    
    environment {
        AWS_ACCOUNT_ID     = '634188077338' 
        AWS_DEFAULT_REGION = 'eu-west-2'
        IMAGE_NAME         = 'jenkins'
        IMAGE_TAG          = "${env.BUILD_NUMBER}"

        REPOSITORY_URI     = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_NAME}"
    }

    stages {
        stage('Checkout'){
           steps {
               git branch: 'main', url: 'https://github.com/hanimao/jenkins-project'
            }
        }
    

        stage('Logging into Amazon ECR') {
            steps {
                script {
              
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                }
            }
        }

        stage('Building Docker Image') {
            steps {
                script {
                
                    sh "docker build -t ${REPOSITORY_URI}:latest -t ${REPOSITORY_URI}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh "docker push ${REPOSITORY_URI}:latest"
                    sh "docker push ${REPOSITORY_URI}:${IMAGE_TAG}"
                }
            }
        }
    } 

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed! Check logs for details.'
        }
    }
}
    

 