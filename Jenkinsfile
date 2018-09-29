#!groovy
pipeline {
    environment {
        REGISTRY_ADDRESS = "reg.ihme.uw.edu"
        REGISTRY_AUTH = credentials("stash-sadatnfs")
        // DEB_TAG = "gcclatest_x2"
        // R_TAG = "5118"
        // FC_TAG = "5118"
    }
	agent any
	stages {

		stage("Buliding Debian Image") {
		  steps {
		    sh "docker build -t reg.ihme.uw.edu/health_fin/debian_base:latest debian_base "
		  }
		}
		
		stage("Push Debian and Build R") {
		    parallel{
		        stage("Pushing Debian Image"){
		            steps{ 
		                sh "docker login -u=$REGISTRY_AUTH_USR -p $REGISTRY_AUTH_PSW ${env.REGISTRY_ADDRESS} && docker push reg.ihme.uw.edu/health_fin/debian_base:latest" 
		            }
		        }
		        stage("Build R Image") {
		            steps{
		                sh "docker build --build-arg DEB_TAG=latest -t reg.ihme.uw.edu/health_fin/r_base:latest r_base "
		            }
		        }
		    }
		}

		stage("Push R and Build Forecasting Image") {
		    parallel{
		        stage("Pushing R Image"){
		            steps{
		                sh "docker login -u=$REGISTRY_AUTH_USR -p $REGISTRY_AUTH_PSW ${env.REGISTRY_ADDRESS} && docker push reg.ihme.uw.edu/health_fin/r_base:latest" 
		            }
		        }
		        stage("Building Forecasting Image") {
		            steps{
		                sh "docker build --build-arg R_TAG=latest -t reg.ihme.uw.edu/health_fin/forecasting:latest forecasting "
		            }
		        }

		    }
		}

        stage("Push Forecasting Image") {
			steps {
           		sh "docker login -u=$REGISTRY_AUTH_USR -p $REGISTRY_AUTH_PSW ${env.REGISTRY_ADDRESS} && docker push reg.ihme.uw.edu/health_fin/forecasting:latest"
           	}
        }
	}
}