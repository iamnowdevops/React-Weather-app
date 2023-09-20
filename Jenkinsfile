pipeline {
    agent any
    environment {
        registryCredential = 'ecr:ap-south-1:awscreds'
        appRegistry = "676974387465.dkr.ecr.ap-south-1.amazonaws.com/vprofileappimg"
        vprofileRegistry = "http://676974387465.dkr.ecr.ap-south-1.amazonaws.com"
    }

    stages{
        stage('Fetch Code'){
            steps{
                git branch: 'master', url: 'https://github.com/iamnowdevops/React-Weather-app.git'
            }
        }

        stage('build && SonarQube analysis') {
            environment {
                scannerHome = tool 'sonar4.7'
            }

            steps {
                withSonarQubeEnv('sonar') {
                    sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                   -Dsonar.projectName=vprofile-repo \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                }
            }
        }

        stage("Quality Gate") {
            steps{
                timeout(time: 1, unit:'HOURS') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true 
                }
            }
        }

        stage('Build App Image') {
            steps{ 
                
                script {
                    dockerImage = docker.build( appRegistry + ":$BUILD_NUMBER", ".")
                }
            }
        }

        stage('Upload App Image') {
            steps{ 
                script {
                    docker.withRegistry( vprofileRegistry, registryCredential) {
                        dockerImage.push("$BUILD_NUMBER")
                        dockerImage.push('latest')
                    }
                }
            }
        }
    }
}