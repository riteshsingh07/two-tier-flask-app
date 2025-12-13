pipeline {
    agent any
    
    environment {
        AWS_DEFAULT_REGION = "us-east-1"
        AWS_ACCOUNT_ID = "705307574472"
        ECR_REPOSIRORY = "flask-app-ecr"
        ECR_URL = "705307574472.dkr.ecr.us-east-1.amazonaws.com/flask-app-ecr"
    }

    stages {
        stage('Cloning') {
            steps {
                echo 'Cloning'
                git url : "https://github.com/riteshsingh07/two-tier-flask-app.git", branch : "main"
                echo "Cloning Done"
            }
        }
        stage('Image Building') {
            steps {
                echo 'Image Building Started'
                sh "docker build -t flask-app-image:latest ."
                echo "Image Building Done"
            }
        }
        stage('Logging in AWS ECR') {
            steps {
                echo "AWS ECR Login"
                withAWS(credentials: 'AWSCred', region: "${AWS_DEFAULT_REGION}") {
                  sh """
                  echo "Logging to ECR"
                  
                  aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | \
                  docker login --username AWS --password-stdin ${ECR_URL}
                  
                  echo "Logging Done"
                  """
                    
                }
        }
    }
       stage ("Pushing to AWS ECR") {
          steps {
              echo "Taging Image"
              sh "docker tag flask-app-image:latest ${ECR_URL}:latest"
              sh "docker push ${ECR_URL}:latest"
              echo "Image Pushed"
          }
        }
    }
}
