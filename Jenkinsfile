pipeline {
    agent any

    stages {
        stage('GitHub Code Checkout') {
            steps {
            checkout scm
            }
        }
        
        stage ("initialise Terraform") {
            steps {
                sh ('terraform init -reconfigure') 
            }
        }
        stage ("Preflight Check") {
            steps {
                sh ('terraform plan') 
            }
        }
                
        stage ("Deploy WebApp") {
            steps {
                echo "Terraform action is --> ${action}"
                sh ('terraform ${action} --auto-approve') 
           }
        }
    }
