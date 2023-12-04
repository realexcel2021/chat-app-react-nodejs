pipeline{
    agent any 

    stages{

        stage("clean ups"){
            sh 'docker compose down'
        }

        stage("build"){
            sh 'docker-compose build --no-cache'
        }

        stage("deploy"){
            sh 'docker-compose up -d'
        }

    }
}