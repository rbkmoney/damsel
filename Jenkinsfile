#!groovy
// -*- mode: groovy -*-

build('damsel', 'docker-host') {
    checkoutRepo()
    loadBuildUtils()

    def pipeDefault
    def gitUtils
    runStage('load pipeline') {
        env.JENKINS_LIB = "build_utils/jenkins_lib"
        pipeDefault = load("${env.JENKINS_LIB}/pipeDefault.groovy")
        pipeJavaProto = load("${env.JENKINS_LIB}/pipeJavaProto.groovy")
        gitUtils = load("${env.JENKINS_LIB}/gitUtils.groovy")
    }

    runStage('compile') {
        withGithubPrivkey {
            sh "make wc_compile"
        }
    }

    pipeDefault() {
        env.skipSonar = 'true'
        pipeJavaProto()
    }
}
