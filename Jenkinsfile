#!groovy

build('damsel', 'docker-host') {
    checkoutRepo()
    loadBuildUtils()

    def pipeDefault
    runStage('load pipeline') {
        env.JENKINS_LIB = "build_utils/jenkins_lib"
        pipeDefault = load("${env.JENKINS_LIB}/pipeDefault.groovy")
    }

    pipeDefault() {

        runStage('compile') {
            sh "make wc_compile"
        }

        if (env.BRANCH_NAME == 'master' || env.BRANCH_NAME.startsWith('epic/')) {
            runStage('Publish Erlang release') {
                withGithubSshCredentials() {
                    sh "make wc_release-erlang"
                }
            }
        }

        runStage('Execute build container') {
            withCredentials([[$class: 'FileBinding', credentialsId: 'java-maven-settings.xml', variable: 'SETTINGS_XML']]) {
                if (env.BRANCH_NAME == 'master') {
                    sh 'make wc_deploy_nexus SETTINGS_XML=$SETTINGS_XML'
                } else if (env.BRANCH_NAME.startsWith('PR-131')) {
                    sh 'make wc_deploy_epic_nexus SETTINGS_XML=$SETTINGS_XML'
                } else {
                    sh 'make wc_java_compile SETTINGS_XML=$SETTINGS_XML'
                }
            }
        }

    }
}
