#!groovy

pipeline('docker-host') {
  docker.withRegistry('https://index.docker.io/v1/',  'dockerhub-rbkmoneycibot') {
    env.REPO_NAME = "damsel"
    def buildImg = docker.image('rbkmoney/build:latest')

    runStage('git checkout') {
      checkout scm
      sh 'git --no-pager log -1 --pretty=format:"%an" > .commit_author'
      env.COMMIT_AUTHOR = readFile('.commit_author').trim()
    }

    runStage('pull build image') {
      buildImg.pull()
    }

    if (env.BRANCH_NAME == 'PR-37'){
    runStage('compile') {

            sh "echo pr- ${env.BRANCH_NAME}"

        if (env.BRANCH_NAME == 'PR-35'){
            sh "echo pr_ ${env.BRANCH_NAME}"
        }
     // sh "make w_container_compile"
    }
    }

    runStage('java_compile') {
      echo ${env.BRANCH_NAME}
      sh "make w_container_java_compile"
    }

    if (env.BRANCH_NAME == 'test_jenkinks') {
        runStage('deploy_nexus') {
          sh "make w_container_deploy_nexus"
        }
    }

    stage 'notify slack'
    slackSend color: 'good', message: "<${env.BUILD_URL}|Build ${env.BUILD_NUMBER}> for ${env.REPO_NAME} by ${env.COMMIT_AUTHOR} has passed on branch ${env.BRANCH_NAME} (jenkins node: ${env.NODE_NAME})."
  }
}

def runStage(String name, Closure body) {
  env.STAGE_NAME = name
  stage "${env.STAGE_NAME}"
  body.call()
}

def pipeline(String label, Closure body) {
  node(label) {
    try {
      body.call()
    } catch (Exception e) {
      stage 'notify slack'
      slackSend color: 'danger', message: "<${env.BUILD_URL}|Build ${env.BUILD_NUMBER}> for ${env.REPO_NAME} by ${env.COMMIT_AUTHOR} has failed on branch ${env.BRANCH_NAME} at stage: ${env.STAGE_NAME} (jenkins node: ${env.NODE_NAME})."

      throw e; // rethrow so the build is considered failed
    } finally {
      runStage('wipe workspace') {
        sh 'docker run --rm -v $PWD:$PWD --workdir $PWD rbkmoney/build:latest /bin/bash -c "rm -rf * .* 2>/dev/null ; echo Wiped"'
      }
    }
  }
}
