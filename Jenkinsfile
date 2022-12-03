pipeline {
    agent any
    tools {
        maven "maven3"
    }
    environment {
        registry = "855607364597.dkr.ecr.ap-northeast-2.amazonaws.com/inventory"
    }

    stages {
        stage('CheckOut') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'jenkinscicd-private', url: 'https://github.com/clove1024/inventory-demo']]])
            }
        }
        stage('BuildJar') {
            steps {
                sh 'mvn clean install -Dmaven.test.skip=true'
            }
        }
        stage('DockerBuild') {
            steps {
                script {
                    docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
        stage('PushImageToECR') {
            steps {
                sh 'aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 855607364597.dkr.ecr.ap-northeast-2.amazonaws.com'
                sh 'docker push "${registry}:${BUILD_NUMBER}"'
            }
        }
        stage('ChangeDeployImageTag') {
            steps {
                sh 'bash set-image-version.sh'
            }
        }
        stage('DeployToK8S') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'mrn-k8s-config', namespace: 'user10', serverUrl: '') {
                    sh 'kubectl apply -f inventory-dep.yaml'
                }
            }
        }
    }
}