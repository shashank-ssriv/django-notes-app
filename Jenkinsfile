pipeline {
    environment {
        BUILD_NUMBER = "${env.BUILD_NUMBER}"
    }
    agent any
    stages {
        stage('Checkout code') {
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/shashank-ssriva/django-notes-app.git'
            }
        }

        stage('Refresh ECR credentials') {
            steps {
                sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 024252866436.dkr.ecr.us-east-1.amazonaws.com'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t django-notes-app:1.0.${BUILD_NUMBER} .'
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh 'docker tag django-notes-app:1.0.${BUILD_NUMBER} 024252866436.dkr.ecr.us-east-1.amazonaws.com/django-notes-app:1.0.${BUILD_NUMBER}'
            }
        }

        stage('Push Docker Image to Registry') {
            steps {
                sh 'docker push 024252866436.dkr.ecr.us-east-1.amazonaws.com/django-notes-app:1.0.${BUILD_NUMBER}'
            }
        }

        stage('Remove Docker image from Jenkins host') {
            steps {
                sh "docker rmi django-notes-app:1.0.${BUILD_NUMBER}"
                sh "docker rmi 024252866436.dkr.ecr.us-east-1.amazonaws.com/django-notes-app:1.0.${BUILD_NUMBER}"
            }
        }

        stage('Pull Helm repo') {
            steps {
                git branch: 'deploy', credentialsId: 'github', url: 'https://github.com/virtualness-io/IaC.git'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh "/usr/bin/envsubst < helm-charts/charts/django-notes-app/values.yaml > /tmp/values.yaml"
                sh "/usr/bin/envsubst < helm-charts/charts/django-notes-app/Chart.yaml > /tmp/Chart.yaml"
                sh "mv /tmp/values.yaml helm-charts/charts/django-notes-app/values.yaml"
                sh "mv /tmp/Chart.yaml helm-charts/charts/django-notes-app/Chart.yaml"
                sh "cd helm-charts/charts/django-notes-app && helm upgrade --install django-notes-app . --values values.yaml"
            }
        }
    }
}