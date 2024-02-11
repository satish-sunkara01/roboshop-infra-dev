pipeline {
    agent {
        node{
            label 'AGENT-1'
        }
    }
    // environment { 
    //     greetings = "Hi I am learning jenkins pipeline"
    // }
    options {
        timeout(time: 1, unit: 'HOURS')
        disableConcurrentBuilds()
        ansiColor('xterm')
    }
    
    stages {
        stage('VPC') {
            steps {
                sh """
                    cd 01-vpc
                    terraform init -reconfigure
                    terraform apply -auto-approve
                """
            }
        }
        stage('SG') {
            steps {
                sh """
                    cd 02-sg
                    terraform init -reconfigure
                    terraform apply -auto-approve
                """
            }
        }
        stage('VPN') {
            steps {
                sh """
                    cd 03-vpn
                    terraform init -reconfigure
                    terraform apply -auto-approve
                """
            }
        }
        stage('DB & ALB') {
            parallel {
                stage('DB') {
                    steps {
                        sh """
                            cd 04-database
                            terraform init -reconfigure
                            terraform apply -auto-approve
                        """
                    }
                }
                stage(' APP-ALB') {
                    steps {
                        sh """
                            cd 05-APP-ALB
                            terraform init -reconfigure
                            terraform apply -auto-approve
                        """
                    }
                }
            }
        }
    }
    post { 
        // always { 
        //     echo 'I will always say Hello again!'
        // }
        failure { 
            echo 'Script is failed'
        }
        success { 
            echo 'Hey Script is success!'
        }
    }
}

