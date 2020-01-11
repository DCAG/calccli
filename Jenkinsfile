pipeline {
  agent any
  stages {
    stage('stage1') {
      parallel {
        stage('stage1') {
          steps {
            powershell(script: 'invoke-psake build.psake.ps1', label: 'build')
            sleep 1
          }
        }

        stage('parallel') {
          steps {
            powershell(script: 'gci env:\\', label: 'environment variables')
          }
        }

      }
    }

  }
}